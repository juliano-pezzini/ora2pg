-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS diagnostico_doenca_gerint ON diagnostico_doenca CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_diagnostico_doenca_gerint() RETURNS trigger AS $BODY$
declare

ie_prim_movimentacao_w			varchar(1);
ie_dados_w			smallint;
nr_seq_interno_w					unidade_atendimento.nr_seq_interno%type;
ds_sep_bv_w						varchar(50);
ie_gerint_w						varchar(1);
ie_leito_integrado_w			bigint;
ie_leito_extra_w				varchar(1);

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger	= 'S')  then
	
select coalesce(max(1),-1)
into STRICT ie_dados_w
from diagnostico_medico
where nr_atendimento = NEW.nr_atendimento
and ie_tipo_diagnostico = 2
and dt_diagnostico = NEW.dt_diagnostico;

if (ie_dados_w = 1 and obter_tipo_convenio_atend(NEW.nr_atendimento) <> 3 and NEW.dt_liberacao is not null) then

	select	CASE WHEN count(*)=1 THEN 'S'  ELSE 'N' END
	into STRICT	ie_prim_movimentacao_w
	from 	atend_paciente_unidade
	where	nr_atendimento = NEW.nr_atendimento;

	if (ie_prim_movimentacao_w = 'S') then

		nr_seq_interno_w := Obter_Unidade_Atendimento(NEW.nr_atendimento, 'A','NR');

		select coalesce(max(1),0)
		into STRICT ie_leito_integrado_w
		from GERINT_EVENTO_INT_DADOS a, GERINT_EVENTO_INTEGRACAO b
		where a.NR_SEQ_EVENTO = b.NR_SEQUENCIA
		and b.id_evento = '25'
		and a.DS_IDENT_LEITO = (SELECT max(x.nm_leito_integracao) from  unidade_atendimento x where x.nr_seq_interno = nr_seq_interno_w)
		and b.nr_atendimento = NEW.nr_atendimento;

		select	coalesce(max(ie_temporario),'N'),
				coalesce(max(ie_gerint),'N')
		into STRICT	ie_leito_extra_w,
				ie_gerint_w
		from 	unidade_atendimento
		where 	nr_seq_interno = nr_seq_interno_w;

		if (ie_gerint_w = 'S' and ie_leito_integrado_w = 0) then
			ds_sep_bv_w	:=	obter_separador_bv;
			--Evento 25: Servico de ocupacao de leito sem solicitacao previa cadastrada no GERINT
			CALL exec_sql_dinamico_bv('TASY', Gerint_desc_de_para('QUERY'), 	'nm_usuario_p='					|| NEW.nm_usuario  						|| ds_sep_bv_w ||
																		'cd_estabelecimento_p=' 		|| obter_estab_atend(NEW.nr_atendimento) 	|| ds_sep_bv_w ||
																		'id_evento_p=' 					|| '25'				 						|| ds_sep_bv_w ||
																		'nr_atendimento_p=' 			|| NEW.nr_atendimento 						|| ds_sep_bv_w ||
																		'ie_leito_extra_p=' 			|| ie_leito_extra_w 						|| ds_sep_bv_w ||
																		'dt_alta_p=' 					|| null 									|| ds_sep_bv_w ||
																		'ds_motivo_alta_p=' 			|| null 									|| ds_sep_bv_w ||
																		'ds_justif_transferencia_p='	|| null 									|| ds_sep_bv_w ||
																		'nr_seq_solic_internacao_p=' 	|| null 									|| ds_sep_bv_w ||
																		'nr_seq_leito_p=' 				|| nr_seq_interno_w							|| ds_sep_bv_w ||
																		'ds_ident_leito_p='				|| null										|| ds_sep_bv_w ||
																		'nr_seq_classif_p=' 			|| null										|| ds_sep_bv_w ||
																		'ie_status_unidade_p=' 			|| null										|| ds_sep_bv_w ||
																		'nr_cpf_paciente_p=' 			|| obter_cpf_pessoa_fisica(NEW.cd_medico)	|| ds_sep_bv_w ||
																		'nr_cartao_sus_p=' 				|| null										|| ds_sep_bv_w ||
																		'cd_cid_p='						|| NEW.cd_doenca 							|| ds_sep_bv_w ||
																		'cd_evolucao_p='				|| null);



		end if;
	end if;
end if;

end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_diagnostico_doenca_gerint() FROM PUBLIC;

CREATE TRIGGER diagnostico_doenca_gerint
	BEFORE INSERT OR UPDATE ON diagnostico_doenca FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_diagnostico_doenca_gerint();

