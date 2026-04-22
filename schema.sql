-- ═══════════════════════════════════════════════════════════════
-- FOREST — personal live stock portfolio
-- Run this in the Supabase SQL editor on a fresh project.
-- ═══════════════════════════════════════════════════════════════

create table if not exists investments (
  id          uuid        primary key default gen_random_uuid(),
  user_id     uuid        not null references auth.users(id) on delete cascade,
  kind        text        not null check (kind in ('public','private')),
  ticker      text,
  name        text,
  notes       text,
  created_at  timestamptz not null default now()
);
create index if not exists investments_user_idx on investments(user_id);

create table if not exists lots (
  id                    uuid        primary key default gen_random_uuid(),
  user_id               uuid        not null references auth.users(id) on delete cascade,
  investment_id         uuid        not null references investments(id) on delete cascade,
  shares                numeric,
  cost_basis_per_share  numeric,
  cost_basis_total      numeric     not null,
  purchase_date         date        not null,
  created_at            timestamptz not null default now()
);
create index if not exists lots_investment_idx on lots(investment_id);
create index if not exists lots_user_idx       on lots(user_id);

create table if not exists valuations (
  id                uuid        primary key default gen_random_uuid(),
  user_id           uuid        not null references auth.users(id) on delete cascade,
  investment_id     uuid        not null references investments(id) on delete cascade,
  valuation_date    date        not null,
  valuation_amount  numeric     not null,
  round_name        text,
  notes             text,
  created_at        timestamptz not null default now()
);
create index if not exists valuations_investment_idx on valuations(investment_id);
create index if not exists valuations_user_idx       on valuations(user_id);

-- Row-level security: each row belongs to a single user
alter table investments enable row level security;
alter table lots        enable row level security;
alter table valuations  enable row level security;

create policy "investments_own" on investments
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "lots_own" on lots
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "valuations_own" on valuations
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
