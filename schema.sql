-- borrowed from https://stackoverflow.com/q/7745609/808921
CREATE TABLE IF NOT EXISTS `users` ( `id` int(6) unsigned NOT NULL, `rev` int(3) unsigned NOT NULL, `content` varchar(200) NOT NULL, PRIMARY KEY (`id`, `rev`) ) DEFAULT CHARSET = utf8;
INSERT INTO
   `users` (`id`, `rev`, `content`)
VALUES
   (
      '1', '1', 'The earth is flat'
   )
,
   (
      '2', '1', 'One hundred angels can dance on the head of a pin'
   )
,
   (
      '1', '2', 'The earth is flat and rests on a bull\'s horn'
   )
,
   (
      '1', '3', 'The earth is like a ball.'
   )
;
CREATE TABLE IF NOT EXISTS `bikes` ( `id` int(6) unsigned NOT NULL, `rev` int(3) unsigned NOT NULL, `content` varchar(200) NOT NULL, PRIMARY KEY (`id`, `rev`) ) DEFAULT CHARSET = utf8;
INSERT INTO
   `bikes` (`id`, `rev`, `content`)
VALUES
   (
      '1', '1', 'The earth is flat'
   )
,
   (
      '2', '1', 'One hundred angels can dance on the head of a pin'
   )
,
   (
      '1', '2', 'The earth is flat and rests on a bull\'s horn'
   )
,
   (
      '1', '3', 'The earth is like a ball.'
   )
;
CREATE TABLE IF NOT EXISTS `trips` ( `id` int(11) unsigned NOT NULL, `user_id` int(11) unsigned NOT NULL, `bike_id` int(11) unsigned NOT NULL, `region_id` int(11) unsigned, `coupon_id` int(11) unsigned, `status` varchar(191) NOT NULL, `cost_amount_cents` int(11) unsigned, `refunded_amount_cents` int(11) unsigned, `started_at` datetime, `created_at` datetime, PRIMARY KEY (`id`) ) DEFAULT CHARSET = utf8;
INSERT INTO
   `trips` (`id`, `user_id`, `bike_id`, `region_id`, `coupon_id`, `status`, `cost_amount_cents`, `refunded_amount_cents`, `started_at`, `created_at`)
VALUES
   (
      '1', '1', '1', '1', '1', 'started', '234', '234', '2017-06-01 00:00:00', '2017-06-02 00:00:00'
   )
,
   (
      '2', '1', '2', '1', NULL, 'failed', '234', '111', '2017-06-01 00:00:00', '2017-06-02 00:00:00'
   )
,
   (
      '3', '2', '1', '1', '3', 'completed', '234', '111', '2017-06-01 00:00:00', '2017-06-02 00:00:00'
   )
,
   (
      '4', '2', '2', '2', '4', 'completed', '234', '234', '2017-06-01 00:00:00', '2017-06-02 00:00:00'
   )
,
   (
      '5', '2', '3', '2', '5', 'completed', '234', '111', '2017-06-01 00:00:00', '2017-06-02 00:00:00'
   )
,
   (
      '6', '2', '3', '2', '6', 'completed', '555', '234', '2017-07-01 00:00:00', '2017-07-02 00:00:00'
   )
,
   (
      '7', '3', '3', '2', '6', 'completed', '234', '111', '2017-08-01 00:00:00', '2017-08-02 00:00:00'
   )
,
   (
      '999', '2', '2', '1', '7', 'started', '234', '234', '2017-06-01 00:00:00', '2017-06-02 00:00:00'
   )
;
CREATE TABLE IF NOT EXISTS `regions` ( `id` int(6) unsigned NOT NULL, `rev` int(3) unsigned NOT NULL, `name` varchar(191) NOT NULL, PRIMARY KEY (`id`, `rev`) ) DEFAULT CHARSET = utf8;
INSERT INTO
   `regions` (`id`, `rev`, `name`)
VALUES
   (
      '1', '1', 'north'
   )
,
   (
      '2', '1', 'west'
   )
,
   (
      '1', '2', 'south'
   )
,
   (
      '1', '3', 'east'
   )
;
CREATE TABLE IF NOT EXISTS `promotions` ( `id` int(6) unsigned NOT NULL, `started_at` datetime, `promotion_name` varchar(191) NOT NULL, PRIMARY KEY (`id`) ) DEFAULT CHARSET = utf8;
INSERT INTO
   `promotions` (`id`, `started_at`, `promotion_name`)
VALUES
   (
      '1', '2017-06-01 00:00:00', 'TestPromo'
   )
,
   (
      '2', '2017-06-01 00:00:00', 'TestPromo2'
   )
;
CREATE TABLE IF NOT EXISTS `coupons` ( `id` int(6) unsigned NOT NULL, `promotion_id` int(3) unsigned NOT NULL, `content` varchar(200) NOT NULL, PRIMARY KEY (`id`) ) DEFAULT CHARSET = utf8;
INSERT INTO
   `coupons` (`id`, `promotion_id`, `content`)
VALUES
   (
      '1', '1', 'The earth is flat'
   )
,
   (
      '2', '1', 'One hundred angels can dance on the head of a pin'
   )
,
   (
      '3', '1', 'The earth is flat and rests on a bull\'s horn'
   )
,
   (
      '4', '1', 'The earth is flat and rests on a bull\'s horn'
   )
,
   (
      '5', '1', 'The earth is flat and rests on a bull\'s horn'
   )
,
   (
      '6', '1', 'The earth is flat and rests on a bull\'s horn'
   )
,
   (
      '7', '1', 'The earth is flat and rests on a bull\'s horn'
   )
,
   (
      '99', '2', 'The earth is like a ball.'
   )
;