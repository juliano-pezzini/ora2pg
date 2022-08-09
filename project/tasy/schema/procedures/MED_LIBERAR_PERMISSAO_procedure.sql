-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE med_liberar_permissao ( cd_pessoa_fisica_p text, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
ie_teste_w		bigint;


BEGIN 
 
insert into med_permissao(	NR_SEQUENCIA, 
					CD_MEDICO_PROP, 
					DT_ATUALIZACAO, 
					NM_USUARIO, 
					IE_PACIENTE, 
					IE_ATENDIMENTO, 
					IE_EVOLUCAO, 
					IE_PROTOCOLO, 
					IE_RECEITA, 
					IE_SOLIC_EXAME, 
					IE_AGENDA, 
					IE_RESULTADO, 
					IE_CONSULTA, 
					IE_FECHAR_ATEND, 
					IE_MED_PADRAO, 
					IE_EXAME_PADRAO, 
					IE_PERMISSAO, 
					IE_CONFIG_RELAT, 
					IE_GRUPO_MEDICO, 
					IE_DIAGNOSTICO, 
					IE_TEXTO_ADICIONAL, 
					IE_REFERENCIA, 
					IE_EIS, 
					IE_ENDERECOS, 
					IE_TEXTO_PADRAO, 
					IE_PARAMETRO, 
					IE_CONFIG_AGENDA, 
					CD_PESSOA_FISICA, 
					CD_MEDICO, 
					NR_SEQ_GRUPO, 
					ie_permite_excluir_agenda, 
					ie_permite_bloquear_agenda) 
SELECT	nextval('med_permissao_seq'), 
		b.cd_pessoa_fisica, 
		clock_timestamp(), 
		nm_usuario_p, 
		IE_PACIENTE, 
		IE_ATENDIMENTO, 
		IE_EVOLUCAO, 
		IE_PROTOCOLO, 
		IE_RECEITA, 
		IE_SOLIC_EXAME, 
		IE_AGENDA, 
		IE_RESULTADO, 
		IE_CONSULTA, 
		IE_FECHAR_ATEND, 
		IE_MED_PADRAO, 
		IE_EXAME_PADRAO, 
		IE_PERMISSAO, 
		IE_CONFIG_RELAT, 
		IE_GRUPO_MEDICO, 
		IE_DIAGNOSTICO, 
		IE_TEXTO_ADICIONAL, 
		IE_REFERENCIA, 
		IE_EIS, 
		IE_ENDERECOS, 
		IE_TEXTO_PADRAO, 
		IE_PARAMETRO, 
		IE_CONFIG_AGENDA, 
		cd_pessoa_fisica_p, 
		null, 
		NR_SEQ_GRUPO, 
		ie_permite_excluir_agenda, 
		ie_permite_bloquear_agenda 
from	pessoa_fisica c, 
	agenda b, 
	med_permissao a 
where a.nr_sequencia = nr_sequencia_p 
 and b.cd_pessoa_fisica = c.cd_pessoa_fisica 
 and a.cd_medico_prop <> b.cd_pessoa_fisica 
 and	not exists (SELECT 1 
	from med_permissao x 
	where cd_medico_prop	= b.cd_pessoa_fisica 
	 and cd_pessoa_fisica	= cd_pessoa_fisica_p);
 
commit;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_liberar_permissao ( cd_pessoa_fisica_p text, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
