-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE integrar_softlab_ws ( nr_seq_evento_p bigint, cd_pessoa_fisica_p text, nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_exame_p bigint, nm_usuario_p text, ie_tipo_validacao_p bigint, ie_commit_p text) AS $body$
DECLARE


ds_sep_bv_w				varchar(100);
ds_param_integ_xml_w	varchar(4000);

incluirSolicitacao_w	smallint := 288;

ie_envia_mensagem_w		varchar(1);
ds_log_w				varchar(2000);
ie_existe_w				varchar(1);


BEGIN
ie_envia_mensagem_w	:= 'N';
ds_log_w		:= '';
ds_sep_bv_w := ';';

if (nr_Seq_evento_p = incluirSolicitacao_w) then

	if (ie_tipo_validacao_p = 1) then
		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_existe_w
		from	prescr_procedimento a,
				lab_exame_equip b,
				equipamento_lab c
		where	a.nr_seq_exame = b.nr_seq_exame
		and		b.cd_equipamento = c.cd_equipamento
		and		a.nr_prescricao = nr_prescricao_p
		and		c.ds_sigla = 'SOFTLABWS';
	elsif (ie_tipo_validacao_p = 2) then
		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_existe_w
		from	lab_exame_equip b,
				equipamento_lab c
		where	b.nr_seq_exame = nr_seq_exame_p
		and		b.cd_equipamento = c.cd_equipamento
		and		c.ds_sigla = 'SOFTLABWS';
	else
		ie_existe_w	:= 'N';
	end if;

	if (ie_existe_w = 'S') then
		if (nr_seq_evento_p = incluirSolicitacao_w) and (wheb_usuario_pck.is_evento_ativo(incluirSolicitacao_w) = 'S') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then

			ds_param_integ_xml_w := 'nr_prescricao=' || to_char(nr_prescricao_p) || ds_sep_bv_w || 'nr_seq_prescr=' || to_char(nr_seq_prescr_p) || ds_sep_bv_w;
			ds_log_w := substr('Softlab - nr_seq_evento_p: '||to_char(nr_seq_evento_p)||' - '||ds_param_integ_xml_w,1,2000);

		end if;

		if (ds_param_integ_xml_w IS NOT NULL AND ds_param_integ_xml_w::text <> '') then
			CALL gravar_log_lab(66, ds_log_w, nm_usuario_p);
			CALL gravar_agend_integracao(nr_seq_evento_p, ds_param_integ_xml_w);

			if (ie_commit_p = 'S') then
				if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
			end if;
		end if;
	end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE integrar_softlab_ws ( nr_seq_evento_p bigint, cd_pessoa_fisica_p text, nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_exame_p bigint, nm_usuario_p text, ie_tipo_validacao_p bigint, ie_commit_p text) FROM PUBLIC;
