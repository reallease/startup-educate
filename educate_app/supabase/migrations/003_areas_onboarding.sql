alter table profiles add column if not exists areas text[] default '{}';
alter table profiles add column if not exists onboarded boolean default false;
