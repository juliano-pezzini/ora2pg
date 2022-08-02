-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rep_obter_valores_imprimir ( nr_prescricao_p bigint, cd_pessoa_fisica_p text, ie_recebeu_alta_p INOUT text, ie_exibe_proced_APH_p INOUT text, ie_exibe_proced_APC_p INOUT text, ie_exibe_proced_AP_p INOUT text, ie_exibe_proced_BS_p INOUT text, nr_seq_autor_p INOUT bigint, ds_lista_relat_p INOUT text, ds_relat_regra_exame_p INOUT text, nr_seq_avaliacao_p INOUT bigint) AS $body$
DECLARE


ie_recebeu_alta_w	varchar(1);
ie_exibe_proced_APH_w	varchar(1);
ie_exibe_proced_APC_w	varchar(1);
ie_exibe_proced_AP_w	varchar(1);
ie_exibe_proced_BS_w	varchar(1);
nr_seq_autor_w		bigint;
ds_lista_relat_w	varchar(255);
ds_relat_regra_exame_w	varchar(2000);
nr_seq_avaliacao_w	bigint;

BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	begin
	select	CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
	into STRICT	ie_recebeu_alta_w
	from	atendimento_paciente
	where	cd_pessoa_fisica = cd_pessoa_fisica_p
	and		coalesce(dt_alta::text, '') = '';

	SELECT  coalesce(MAX(nr_sequencia),0)
	into STRICT	nr_seq_avaliacao_w
	FROM 	med_avaliacao_paciente
	WHERE 	nr_prescricao = nr_prescricao_p
	AND 	ie_situacao = 'A';


	if (ie_recebeu_alta_w = 'N') then
		begin

		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_exibe_proced_APH_w
		from	prescr_procedimento
		where	nr_prescricao	= nr_prescricao_p
		and	obter_se_exibe_proced(nr_prescricao,nr_sequencia,ie_tipo_proced,'APH') = 'S';

		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_exibe_proced_APC_w
		from	prescr_procedimento
		where	nr_prescricao	= nr_prescricao_p
		and	obter_se_exibe_proced(nr_prescricao,nr_sequencia,ie_tipo_proced,'APC') = 'S';

		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_exibe_proced_AP_w
		from	prescr_procedimento
		where	nr_prescricao	= nr_prescricao_p
		and	obter_se_exibe_proced(nr_prescricao,nr_sequencia,ie_tipo_proced,'AP') = 'S';

		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_exibe_proced_BS_w
		from	prescr_procedimento
		where	nr_prescricao	= nr_prescricao_p
		and (obter_se_exibe_proced(nr_prescricao,nr_sequencia,ie_tipo_proced,'BSHE') = 'S'
		or	obter_se_exibe_proced(nr_prescricao,nr_sequencia,ie_tipo_proced,'BSST') = 'S');

		select	max(nr_sequencia)
		into STRICT	nr_seq_autor_w
		from	autorizacao_convenio
		where	nr_prescricao	= nr_prescricao_p;

		ds_lista_relat_w	:= substr(rep_obter_todos_relat_regra,1,255);

		ds_relat_regra_exame_w	:= rep_obter_relatorio_regra_imp(nr_prescricao_p);
		end;
	end if;
	end;
end if;
commit;
ie_recebeu_alta_p	:= ie_recebeu_alta_w;
ie_exibe_proced_APH_p	:= ie_exibe_proced_APH_w;
ie_exibe_proced_APC_p	:= ie_exibe_proced_APC_w;
ie_exibe_proced_AP_p	:= ie_exibe_proced_AP_w;
ie_exibe_proced_BS_p	:= ie_exibe_proced_BS_w;
nr_seq_autor_p		:= nr_seq_autor_w;
ds_lista_relat_p	:= ds_lista_relat_w;
ds_relat_regra_exame_p	:= ds_relat_regra_exame_w;
nr_seq_avaliacao_p	:= nr_seq_avaliacao_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rep_obter_valores_imprimir ( nr_prescricao_p bigint, cd_pessoa_fisica_p text, ie_recebeu_alta_p INOUT text, ie_exibe_proced_APH_p INOUT text, ie_exibe_proced_APC_p INOUT text, ie_exibe_proced_AP_p INOUT text, ie_exibe_proced_BS_p INOUT text, nr_seq_autor_p INOUT bigint, ds_lista_relat_p INOUT text, ds_relat_regra_exame_p INOUT text, nr_seq_avaliacao_p INOUT bigint) FROM PUBLIC;

