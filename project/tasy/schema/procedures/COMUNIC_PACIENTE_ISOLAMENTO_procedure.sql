-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE comunic_paciente_isolamento ( ds_perfil_p text, nr_atendimento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

nm_paciente_w	varchar(60);
ds_unidade_w	varchar(21);


BEGIN

select	substr(obter_nome_pf(cd_pessoa_fisica),1,60),
		cd_unidade
into STRICT	nm_paciente_w,
		ds_unidade_w
from	Ocupacao_Unidade_v
where	nr_atendimento = nr_atendimento_p
and		ie_acompanhante = 'N';

INSERT  INTO comunic_interna(
		dt_comunicado,
		ds_titulo,
		ds_comunicado,
		nm_usuario,
		dt_atualizacao,
		ie_geral,
		nm_usuario_destino,
		nr_sequencia,
		ie_gerencial,
		nr_seq_classif,
		ds_perfil_adicional,
		cd_setor_destino,
		cd_estab_destino,
		ds_setor_adicional,
		dt_liberacao)
VALUES (	clock_timestamp(),



		OBTER_DESC_EXPRESSAO(295163),
		WHEB_MENSAGEM_PCK.get_texto(457549,'nm_paciente_w='||nm_paciente_w||';nr_atendimento_p='
			||nr_atendimento_p||';ds_unidade_w='||ds_unidade_w),
		nm_usuario_p,
		clock_timestamp(),
		'N',
		null,
		nextval('comunic_interna_seq'),
		'N',
		null,
		ds_perfil_p,
		null,
		cd_estabelecimento_p,
		null,
		clock_timestamp());
if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE comunic_paciente_isolamento ( ds_perfil_p text, nr_atendimento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
