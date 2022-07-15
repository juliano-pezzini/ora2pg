-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_dados_controle_glicemico ( nr_prescricao_p bigint, nr_seq_prot_glic_p bigint, nr_prescricoes_p text, nr_prescr_p INOUT bigint, nr_seq_glicemia_p INOUT bigint, ds_prot_glic_p INOUT text) AS $body$
DECLARE


nr_prescr_w		bigint	:= 0;
nr_seq_glicemia_w		integer;
ds_prot_glic_w		varchar(80);


BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then
	nr_prescr_w	:= nr_prescricao_p;
else
	nr_prescr_w	:= Obter_Max_NrPrescricao(nr_prescricoes_p);
end if;

if (nr_prescr_w > 0) then
	begin
	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_glicemia_w
	from	prescr_procedimento
	where	nr_prescricao	= nr_prescr_w
	and	nr_seq_prot_glic	= nr_seq_prot_glic_p;

	if (nr_seq_glicemia_w > 0) then
		select	substr(obter_nome_prot_glic(nr_seq_Prot_glic),1,80)
		into STRICT	ds_prot_glic_w
		from	prescr_procedimento
		where	nr_prescricao	= nr_prescr_w
		and	nr_sequencia	= nr_seq_glicemia_w;
	end if;
	end;
end if;

nr_prescr_p		:= nr_prescr_w;
nr_seq_glicemia_p		:= nr_seq_glicemia_w;
ds_prot_glic_p		:= ds_prot_glic_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_dados_controle_glicemico ( nr_prescricao_p bigint, nr_seq_prot_glic_p bigint, nr_prescricoes_p text, nr_prescr_p INOUT bigint, nr_seq_glicemia_p INOUT bigint, ds_prot_glic_p INOUT text) FROM PUBLIC;

