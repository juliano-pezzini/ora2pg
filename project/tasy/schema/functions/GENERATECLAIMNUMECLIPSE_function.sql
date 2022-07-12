-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION generateclaimnumeclipse () RETURNS varchar AS $body$
DECLARE

  w      bigint := 0;
  a      varchar(10);
  result varchar(50);

BEGIN
    SELECT Upper(dbms_random.String('a', 1)) 
    INTO STRICT   a 
;
    
     select CASE WHEN MOD((nextval('eclipse_claim_seq')),10000)=0 THEN  1  ELSE MOD((nextval('eclipse_claim_seq')),10000) END 
     INTO STRICT   w
;

    result := ( a
                || Lpad(To_char(w), 4, '0') 
                || '@' );

    RETURN result;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION generateclaimnumeclipse () FROM PUBLIC;

