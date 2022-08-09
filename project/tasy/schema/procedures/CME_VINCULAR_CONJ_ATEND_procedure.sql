-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cme_vincular_conj_atend ( cd_barras_p bigint, nr_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nm_paciente_w		varchar(100);	
nr_atendimento_w	bigint;
ds_observacao_w		varchar(255);
dt_validade_w		timestamp;
nr_cirurgia_w		bigint;
nr_atendimento_ww	bigint;
ie_local_estoque_w	varchar(10);
cd_local_estoque_w	bigint;
cd_setor_atendimento_w	bigint;
ie_retorno_w		varchar(10);
ie_status_conjunto_w	varchar(20);
cd_local_repassar_w	bigint;
ds_setor_atendimento_w	varchar(255);
ie_lib_registro_vinc_conj_w varchar(2);


BEGIN

select	substr(obter_pessoa_atendimento(nr_atendimento_p,'N'),1,100)
into STRICT	nm_paciente_w
;

select	max(cd_setor_atendimento)
into STRICT	cd_setor_atendimento_w
from	atendimento_paciente_v
where	nr_atendimento	= nr_atendimento_p;

select	substr(obter_nome_setor(cd_setor_atendimento_w),1,50)
into STRICT	ds_setor_atendimento_w
;

/*Paciente: #@NM_PACIENTE_W#@ Num Atend.: #@NR_ATENDIMENTO_P#@ Setor: #@DS_SETOR_ATENDIMENTO_W#@*/

ds_observacao_w	:= substr(wheb_mensagem_pck.get_texto(303499,'NM_PACIENTE_W=' || nm_paciente_w || ';NR_ATENDIMENTO_P=' || nr_atendimento_p || ';DS_SETOR_ATENDIMENTO_W=' || ds_setor_atendimento_w),1,255);
ie_local_estoque_w := obter_param_usuario(281, 927, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_local_estoque_w);
ie_retorno_w := obter_param_usuario(281, 928, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_retorno_w);
ie_status_conjunto_w := obter_param_usuario(281, 929, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_status_conjunto_w);
cd_local_repassar_w := obter_param_usuario(281, 949, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, cd_local_repassar_w);
ie_lib_registro_vinc_conj_w := obter_param_usuario(88, 355, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_lib_registro_vinc_conj_w);

begin

select	nr_atendimento,
	dt_validade,
	nr_cirurgia
into STRICT	nr_atendimento_w,
	dt_validade_w,
	nr_cirurgia_w
from	cm_conjunto_cont
where	nr_sequencia	= cd_barras_p
and	coalesce(ie_situacao,'A') = 'A';

exception
	when others then
	-- Conjunto nao encontrado!
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(153617);
end;



if (ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(coalesce(dt_validade_w,clock_timestamp())) < ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(clock_timestamp())) then
	-- Este conjunto nao esta dentro do prazo de validade.
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(264815);
end if;

if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then
	-- Este conjunto possui um atendimento vinculado! Atendimento: nr_atendimento_w
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(264856,'NR_ATENDIMENTO=' || NR_ATENDIMENTO_W);
elsif (nr_cirurgia_w IS NOT NULL AND nr_cirurgia_w::text <> '') then
	select	nr_atendimento
	into STRICT	nr_atendimento_ww
	from	cirurgia
	where	nr_cirurgia = nr_cirurgia_w;
	--Este conjunto possui uma cirurgia vinculada!. Cirurgia: nr_cirurgia_w . Atendimento: nr_atendimento_ww
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(264857,'NR_CIRURGIA=' || nr_cirurgia_w || ';NR_ATENDIMENTO=' || nr_atendimento_ww);
else
	if (ie_local_estoque_w	= 'S') then
		
		select	max(coalesce(cd_local_estoque_cme,cd_local_estoque))
		into STRICT	cd_local_estoque_w
		from	setor_atendimento
		where	cd_setor_atendimento	= cd_setor_atendimento_w;
	end if;

	if (cd_local_repassar_w <> 0) then
		cd_local_estoque_w	:= cd_local_repassar_w;
	end if;

	update	cm_conjunto_cont
	set	nr_atendimento	= nr_atendimento_p,
		ds_observacao	= ds_observacao_w,
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p,
		NM_USUARIO_VINC	= nm_usuario_p,
		DT_VINCULO_CONJ = clock_timestamp(),
		cd_local_estoque = cd_local_estoque_w,
		ie_status_conjunto	= coalesce(ie_status_conjunto_w,ie_status_conjunto),
		dt_liberacao = CASE WHEN ie_lib_registro_vinc_conj_w='S' THEN  clock_timestamp()  ELSE null END
	where	nr_sequencia	= cd_barras_p;
	if (ie_retorno_w	= 'S')  and (cm_obter_se_apenas_descartavel(cd_barras_p)	= 'S')then
		update	cm_requisicao_conj
		set	dt_retorno  = clock_timestamp()
		where	NR_SEQ_CONJ_REAL	= cd_barras_p
		and	coalesce(dt_retorno::text, '') = '';
		
	end if;
	
	commit;
	 CALL gerar_lancamento_automatico(nr_atendimento_p,null,332,nm_usuario_p,null,cd_barras_p,null,null,null,null);
	
	commit;
end if;



end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cme_vincular_conj_atend ( cd_barras_p bigint, nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;
