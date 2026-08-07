-- Peer consult channel.
--
-- Reference schema for SQLite. The same shape works on any relational store;
-- on a server database, prefer enforcing `sender` from the authenticated role
-- (a row-level-security policy or a column default drawn from the session user)
-- rather than trusting the client to supply it.

CREATE TABLE IF NOT EXISTS agent_messages (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,

    -- Constraint 2: sender identity is enforced, not claimed. On SQLite the
    -- CHECK below restricts it to known agents; the calling code must set it
    -- from its own configured identity and never from user or peer input.
    sender       TEXT NOT NULL CHECK (sender IN ('agent-a', 'agent-b')),
    recipient    TEXT NOT NULL CHECK (recipient IN ('agent-a', 'agent-b')),

    body         TEXT NOT NULL,

    -- Constraint 4: replies terminate. A row with in_reply_to set is an ANSWER.
    -- Answers are never themselves answered - the poller must not generate a
    -- turn for them, only deliver them.
    in_reply_to  INTEGER REFERENCES agent_messages(id),

    status       TEXT NOT NULL DEFAULT 'unread'
                 CHECK (status IN ('unread', 'read', 'done', 'error')),
    error        TEXT,
    created_at   TEXT NOT NULL DEFAULT (datetime('now'))
);

-- A peer must never talk to itself: a self-addressed message is the simplest
-- way to build an infinite loop.
CREATE TRIGGER IF NOT EXISTS no_self_send
BEFORE INSERT ON agent_messages
WHEN NEW.sender = NEW.recipient
BEGIN
    SELECT RAISE(ABORT, 'sender and recipient must differ');
END;

CREATE INDEX IF NOT EXISTS idx_agent_messages_inbox
    ON agent_messages (recipient, status, id);
