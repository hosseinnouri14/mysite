-- اگر قبلاً supabase.sql را اجرا کرده‌اید، فقط همین فایل را در SQL Editor اجرا کنید
drop table if exists slots;
create table slots (
  day    int  not null check (day between 0 and 6),
  slot   int  not null check (slot between 0 and 47),  -- هر عدد یک نیم‌ساعت است: ۱۶ = ۸:۰۰ تا ۸:۳۰
  status text not null default 'free' check (status in ('free','booked')),
  primary key (day, slot)
);
alter table slots enable row level security;
create policy "slots read"  on slots for select to anon, authenticated using (true);
create policy "slots admin" on slots for all    to authenticated using (true) with check (true);
grant select on slots to anon, authenticated;
grant insert, update, delete on slots to authenticated;

alter table bookings add column if not exists source text check (char_length(source) <= 40);
alter table bookings add column if not exists slot_keys text[];
