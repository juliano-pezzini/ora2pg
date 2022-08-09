-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE adep_exec_lancto_dispositivo ( nr_atendimento_p bigint, nr_seq_disp_proc_p bigint, nm_usuario_p text) AS $body$
DECLARE


Ie_Lancto_disp_ret_w	varchar(1) := 'N';
cd_setor_Atendimento_w	bigint;
nr_seq_proc_interno_w	bigint;
cd_procedimento_w	bigint;
ie_origem_proc_w	smallint;
cd_categoria_w		varchar(10);
cd_convenio_w		integer;
nr_Atendimento_w	bigint;
cd_plano_w		varchar(10);
cd_tipo_acomodacao_w	smallint;


BEGIN
Ie_Lancto_disp_ret_w := obter_param_usuario(1113, 315, wheb_usuario_pck.get_cd_perfil, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, Ie_Lancto_disp_ret_w);

if (Ie_Lancto_disp_ret_w = 'S') then
	if	coalesce(nr_atendimento_p::text, '') = '' then
		Select	nr_atendimento
		into STRICT	nr_Atendimento_w
		from	ATEND_PAC_DISP_PROC b,
			ATEND_PAC_DISPOSITIVO c
		where	b.nr_sequencia	= nr_seq_disp_proc_p
		and	c.nr_sequencia	= b.nr_seq_disp_pac;
	else
		nr_Atendimento_w	:= nr_atendimento_p;
	end if;

	Select	NR_SEQ_PROC_INTERNO,
		cd_setor_atendimento
	into STRICT	nr_seq_proc_interno_w,
		cd_setor_Atendimento_w
	from	ATEND_PAC_DISP_PROC b
	where	b.nr_sequencia	= nr_seq_disp_proc_p;

	begin
	select	cd_convenio,
		cd_categoria,
		cd_plano_convenio,
		cd_tipo_acomodacao
	into STRICT	cd_convenio_w,
		cd_categoria_w,
		cd_plano_w,
		cd_tipo_acomodacao_w
	from 	atend_categoria_convenio
	where	nr_seq_interno = Obter_Atecaco_atendimento(nr_Atendimento_w)
	and 	nr_Atendimento = nr_Atendimento_w;
	exception
	when no_data_found then
		-- O atendimento #@NR_ATENDIMENTO#@ não possui convênio definido na Entrada Única!
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(192069,'NR_ATENDIMENTO=' || nr_Atendimento_w);
	end;

	SELECT * FROM OBTER_PROC_TAB_INTERNO_CONV(	nr_seq_proc_interno_w, wheb_usuario_pck.get_cd_estabelecimento, cd_convenio_w, cd_categoria_w, cd_plano_w, cd_setor_Atendimento_w, cd_procedimento_w, ie_origem_proc_w, null, clock_timestamp(), cd_tipo_acomodacao_w, null, null, null, null, null, null, null) INTO STRICT cd_procedimento_w, ie_origem_proc_w;
	CALL ADEP_gerar_lancto_Dispositivo(nr_seq_proc_interno_w, nr_seq_disp_proc_p, nr_Atendimento_w, cd_procedimento_w, ie_origem_proc_w, 	1, nm_usuario_p);
end if;


if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE adep_exec_lancto_dispositivo ( nr_atendimento_p bigint, nr_seq_disp_proc_p bigint, nm_usuario_p text) FROM PUBLIC;
