-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ctb_online_pck.request_lock (lock_name_p text) RETURNS varchar AS $body$
DECLARE

  lock_status_w integer;
  lock_handle_w varchar(128);


BEGIN

  dbms_lock.allocate_unique(lockname 		=> lock_name_p,
			     lockhandle 	=> lock_handle_w,
			     expiration_secs	=> 60); -- 60 segundos

  lock_status_w := dbms_lock.request(lockhandle => lock_handle_w,
				     lockmode	=> dbms_lock.x_mode, --exclusivo
				     timeout	=> dbms_lock.maxwait); -- espera eternamente
  return lock_handle_w;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ctb_online_pck.request_lock (lock_name_p text) FROM PUBLIC;