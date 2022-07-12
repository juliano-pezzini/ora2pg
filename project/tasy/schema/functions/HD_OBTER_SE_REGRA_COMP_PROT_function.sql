-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_obter_se_regra_comp_prot (cd_pessoa_fisica_p text, nr_seq_protocolo_exc_p bigint, nr_seq_proc_medic_exc_p bigint, dt_refencia_p timestamp) RETURNS varchar AS $body$
DECLARE

ds_retorno_w	varchar(1);
qt_itens_w	integer;

BEGIN

ds_retorno_w	:= 'S';

if (nr_seq_proc_medic_exc_p IS NOT NULL AND nr_seq_proc_medic_exc_p::text <> '' AND nr_seq_protocolo_exc_p IS NOT NULL AND nr_seq_protocolo_exc_p::text <> '') then

	select  count(*)
	into STRICT	qt_itens_w
	from	hd_pac_prot_exame
	where	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(obter_prox_data_ref(ie_forma_solic, nr_dia, nr_mes,''))	= ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_refencia_p)
	and	cd_pessoa_fisica = cd_pessoa_fisica_p
	and	nr_seq_proc_medic = nr_seq_proc_medic_exc_p
	and	nr_seq_protocolo = nr_seq_protocolo_exc_p;
	
	if (qt_itens_w > 0) then
		ds_retorno_w	:= 'N';
	end if;
end if;

return ds_retorno_w;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_se_regra_comp_prot (cd_pessoa_fisica_p text, nr_seq_protocolo_exc_p bigint, nr_seq_proc_medic_exc_p bigint, dt_refencia_p timestamp) FROM PUBLIC;

