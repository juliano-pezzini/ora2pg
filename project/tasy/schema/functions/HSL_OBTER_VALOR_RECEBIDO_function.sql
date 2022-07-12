-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hsl_obter_valor_recebido ( nr_interno_conta_p bigint) RETURNS bigint AS $body$
DECLARE

 
vl_recebido_w      double precision:= 0;
vl_recebido_tit_w    double precision:= 0;
nr_titulo_w       bigint;

 
c01 CURSOR FOR 
    SELECT /*+ index (a titrece_conpaci_fk_i) */ 
        nr_titulo 
    FROM  titulo_receber a 
    WHERE (nr_interno_conta_p <> 0) 
    AND (nr_interno_conta = nr_interno_conta_p);


BEGIN 
 
OPEN c01;
LOOP 
FETCH c01 INTO 
    nr_titulo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
    begin 
    vl_recebido_tit_w:= 0;
 
    select coalesce(sum(vl_recebido),0) 
    into STRICT  vl_recebido_tit_w 
    from  titulo_receber_liq 
    where  nr_titulo = nr_titulo_w 
	and	cd_tipo_recebimento not in (7,8,9,14,20,21);
 
    vl_recebido_w := vl_recebido_w + vl_recebido_tit_w;
    end;
END LOOP;
CLOSE c01;
 
return vl_recebido_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hsl_obter_valor_recebido ( nr_interno_conta_p bigint) FROM PUBLIC;
