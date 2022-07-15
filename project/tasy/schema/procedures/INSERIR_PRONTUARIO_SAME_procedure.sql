-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_prontuario_same (ie_tipo_p text, cd_pessoa_fisica_p text, nr_atendimento_p bigint, nr_seq_caixa_p bigint, cd_setor_atendimento_p bigint, nr_seq_local_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, dt_periodo_inicial_p timestamp, dt_periodo_final_p timestamp, nr_interno_conta_p bigint default null, nr_seq_tipo_p bigint default null) AS $body$
DECLARE


nr_seq_volume_w		bigint;
nr_seq_prontuario_w	bigint;
nr_seq_local_w		bigint;
ds_parametro_w		varchar(10) := obter_valor_param_usuario(941,103,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_p);
ie_caixa_liberada_w	varchar(1);
ie_caixa_liberacao_w	varchar(1);
				

BEGIN

if (nr_seq_caixa_p IS NOT NULL AND nr_seq_caixa_p::text <> '') then

	ie_caixa_liberada_w := Obter_Param_Usuario(941, 204, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_caixa_liberada_w);

	select 	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_caixa_liberacao_w
	from 	same_caixa
	where 	nr_sequencia = nr_seq_caixa_p
	and 	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');

	if (coalesce(ie_caixa_liberada_w,'N') = 'S') and (coalesce(ie_caixa_liberacao_w,'N') = 'S') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(213407);
	end if;

end if;


if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '')  then
	
	select 	coalesce(max(nr_seq_volume),0)+1
	into STRICT	nr_seq_volume_w
	from	same_prontuario
	where	cd_pessoa_fisica= cd_pessoa_fisica_p
	and	((ds_parametro_w = 'N') or (cd_estabelecimento = cd_estabelecimento_p));

	select	nextval('same_prontuario_seq')
	into STRICT	nr_seq_prontuario_w
	;
	
	nr_seq_local_w	:= coalesce(nr_seq_local_p,0);
	
	if (nr_seq_local_w = 0) then
		begin
		Select 	max(nr_sequencia)
		into STRICT	nr_seq_local_w
		from 	same_local
		where 	ie_situacao = 'A'
		 and 	ie_local_base = 'S';
		end;
	end if;
	
	insert into same_prontuario(
		nr_sequencia,
		cd_estabelecimento,
		ie_tipo,
		dt_atualizacao,
		nm_usuario,
		ie_status,
		cd_pessoa_fisica,
		nr_atendimento,
		nr_seq_caixa,
		nr_seq_local,
		ie_digitalizado,
		ie_microfilmado,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_setor_atendimento,
		nr_seq_volume,
		dt_periodo_inicial,
		dt_periodo_final,
		ie_forma_geracao_pront,
		cd_funcao,
  		nr_interno_conta,
      nr_seq_tipo)
	values ( nr_seq_prontuario_w,	
		cd_estabelecimento_p,
		ie_tipo_p,
		clock_timestamp(),
		nm_usuario_p,
		1,
		cd_pessoa_fisica_p,
		nr_atendimento_p,
		CASE WHEN coalesce(nr_seq_caixa_p::text, '') = '' THEN null  ELSE nr_seq_caixa_p END ,
		nr_seq_local_w,
		'N',
		'N',
		clock_timestamp(),
		nm_usuario_p,
		cd_setor_atendimento_p,
		nr_seq_volume_w,
		dt_periodo_inicial_p,
		dt_periodo_final_p,
		'A',
		obter_funcao_ativa,
		nr_interno_conta_p,
      nr_seq_tipo_p);
	commit;
					
	CALL Gestao_Prontuario_Same(nr_seq_prontuario_w,nm_usuario_p,null,null,nr_seq_local_p,nr_seq_caixa_p,null,null,8,null,null,null);

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_prontuario_same (ie_tipo_p text, cd_pessoa_fisica_p text, nr_atendimento_p bigint, nr_seq_caixa_p bigint, cd_setor_atendimento_p bigint, nr_seq_local_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, dt_periodo_inicial_p timestamp, dt_periodo_final_p timestamp, nr_interno_conta_p bigint default null, nr_seq_tipo_p bigint default null) FROM PUBLIC;

