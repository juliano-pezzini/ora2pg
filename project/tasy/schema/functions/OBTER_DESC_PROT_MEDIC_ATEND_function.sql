-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_prot_medic_atend ( nr_seq_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);
ds_protocolo_w	varchar(255);
nr_seq_pac_w	bigint;


BEGIN

if (coalesce(nr_seq_atendimento_p,0) > 0) then
	select	coalesce(nr_seq_paciente,0)
	into STRICT	nr_seq_pac_w
	from	paciente_atendimento
	where	nr_seq_atendimento = nr_seq_atendimento_p;
end if;

select substr(coalesce(substr(obter_desc_prot_medic(nr_seq_pac_w),1,255),WHEB_MENSAGEM_PCK.get_texto(299025,null)),1,255)
into STRICT ds_protocolo_w
;

ds_retorno_w := ds_protocolo_w;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_prot_medic_atend ( nr_seq_atendimento_p bigint) FROM PUBLIC;
