-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_pls_ajusta_param_ops_auto () AS $body$
BEGIN

update FUNCAO_PARAMETRO
set	DS_PARAMETRO			= 'Permite inserir itens com o mesmo código',
	VL_PARAMETRO_PADRAO		= 'S',
	VL_PARAMETRO			= '',
	DS_OBSERVACAO			= 'Permite inserir na autorização itens com o mesmo código.Ex: Inserir 2 vezes o código 10101012.Se o valor estiver como ''N'' será necessário alterar a quantidade do item lançado.',
	DS_DEPENDENCIA			= '',
	IE_NIVEL_LIBERACAO		= 'Q',
	DS_OBSERVACAO_CLIENTE		= '',
	IE_AUDITORIA			= '',
	DT_ATUALIZACAO			= TO_DATE('20/08/2012 17:24:44','dd/mm/yyyy hh24:mi:ss'),
	NM_USUARIO			= 'ejsilva',
	CD_DOMINIO			= 6,
	NR_SEQ_APRESENTACAO		= 500,
	DT_ATUALIZACAO_NREC		= TO_DATE('03/08/2011 07:45:51','dd/mm/yyyy hh24:mi:ss'),
	NM_USUARIO_NREC			= 'ejsilva',
	NR_SEQ_ORDEM			= 476388,
	NR_SEQ_CLASSIFICACAO		= 7,
	NR_SEQ_AGRUP			= 364,
	DS_SQL				= '',
	NR_SEQ_LOCALIZADOR		= '',
	IE_SITUACAO_DELPHI		= 'A',
	IE_SITUACAO_SWING		= 'I',
	DT_LIBERACAO			= TO_DATE('03/08/2011 07:45:51','dd/mm/yyyy hh24:mi:ss'),
	NM_USUARIO_LIB			= 'ejsilva'
where	NR_SEQUENCIA	= 39
and	CD_FUNCAO	= 1204;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_pls_ajusta_param_ops_auto () FROM PUBLIC;
