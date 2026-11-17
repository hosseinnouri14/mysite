-- این کد را یک‌بار در Supabase > SQL Editor اجرا کنید
create table slots (
  day  int not null check (day between 0 and 6),
  hour int not null check (hour between 0 and 23),
  primary key (day, hour)
);
create table bookings (
  id bigint generated always as identity primary key,
  created_at timestamptz not null default now(),
  name    text not null check (char_length(name) <= 80),
  contact text not null check (char_length(contact) <= 120),
  topic   text check (char_length(topic) <= 80),
  mode    text check (char_length(mode) <= 40),
  times   text[],
  msg     text check (char_length(msg) <= 1500),
  status  text not null default 'new' check (status in ('new','done'))
);
alter table slots    enable row level security;
alter table bookings enable row level security;

-- همه می‌توانند زمان‌های آزاد را ببینند؛ فقط مدیر وارد‌شده تغییرشان می‌دهد
create policy "slots read"  on slots for select to anon, authenticated using (true);
create policy "slots admin" on slots for all    to authenticated using (true) with check (true);
-- همه می‌توانند رزرو ثبت کنند؛ فقط مدیر می‌تواند ببیند، تغییر دهد یا حذف کند
create policy "bookings insert" on bookings for insert to anon, authenticated with check (status = 'new');
create policy "bookings read"   on bookings for select to authenticated using (true);
create policy "bookings update" on bookings for update to authenticated using (true) with check (true);
create policy "bookings delete" on bookings for delete to authenticated using (true);

grant select on slots to anon, authenticated;
grant insert, update, delete on slots to authenticated;
grant insert on bookings to anon;
grant select, insert, update, delete on bookings to authenticated;
