-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_req_diagnostico_web ( NM_USUARIO_P text, NR_SEQ_REQUISICAO_P text, IE_UNIDADE_TEMPO_P text, QT_TEMPO_P text, IE_TIPO_DOENCA_P text, ie_indicacao_acidente_p text, CD_DOENCA_P text, IE_CLASSIFICACAO_P text ) AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:   Gerar diagnósticos da requisição para autorização no portal web
----------------------------------------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [ x ] Portal [  ] Relatórios [ ] Outros:
 ----------------------------------------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/BEGIN

if ((cd_doenca_p IS NOT NULL AND cd_doenca_p::text <> '') or (ie_tipo_doenca_p IS NOT NULL AND ie_tipo_doenca_p::text <> '') or (ie_indicacao_acidente_p IS NOT NULL AND ie_indicacao_acidente_p::text <> '') or (qt_tempo_p IS NOT NULL AND qt_tempo_p::text <> '')) then
	insert into pls_requisicao_diagnostico(nr_sequencia, dt_atualizacao, dt_atualizacao_nrec,
		nm_usuario, nm_usuario_nrec, nr_seq_requisicao,
		ie_unidade_tempo, qt_tempo, ie_tipo_doenca,
		ie_indicacao_acidente, cd_doenca, ie_classificacao)
	values (nextval('pls_requisicao_diagnostico_seq'), clock_timestamp(), clock_timestamp(),
		nm_usuario_p, nm_usuario_p, nr_seq_requisicao_p,
		ie_unidade_tempo_p, qt_tempo_p, ie_tipo_doenca_p,
		ie_indicacao_acidente_p, upper(cd_doenca_p),ie_classificacao_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_req_diagnostico_web ( NM_USUARIO_P text, NR_SEQ_REQUISICAO_P text, IE_UNIDADE_TEMPO_P text, QT_TEMPO_P text, IE_TIPO_DOENCA_P text, ie_indicacao_acidente_p text, CD_DOENCA_P text, IE_CLASSIFICACAO_P text ) FROM PUBLIC;

