-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE agenda_paciente_afterpost_js ( nr_seq_agenda_p bigint, cd_procedimento_p bigint, nr_seq_proc_interno_p bigint, cd_convenio_p bigint, ie_autorizacao_p text, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, ds_retorno_p INOUT text) AS $body$
DECLARE


ie_cancelar_autorizacao_w	varchar(255);
ie_atualiza_estagio_aut_w	varchar(255);
nr_seq_estagio_cancel_w		bigint;
nr_seq_aut_cancel_w		bigint;
nr_seq_estagio_autor_w		bigint;
nr_seq_autorizacao_w		bigint;
ds_retorno_w			varchar(255);
ds_erro_w			varchar(150);

c01 CURSOR FOR
	SELECT	nr_sequencia
	from	autorizacao_convenio
	where	nr_seq_agenda	= nr_seq_agenda_p
	and	cd_convenio   	<> cd_convenio_p;

c02 CURSOR FOR
	SELECT	nr_sequencia
	from	autorizacao_convenio
	where	nr_seq_agenda	= nr_seq_agenda_p
	and 	cd_convenio 	= cd_convenio_p;


BEGIN

if (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') then
	begin
	ie_cancelar_autorizacao_w := Obter_Param_Usuario(820, 151, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_cancelar_autorizacao_w);
	if (ie_cancelar_autorizacao_w = 'S') then
		begin
		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_seq_estagio_cancel_w
		from	estagio_autorizacao
		where	ie_interno = 70
		and		OBTER_EMPRESA_ESTAB(wheb_usuario_pck.get_cd_estabelecimento) = cd_empresa;

		if (nr_seq_estagio_cancel_w > 0) then
			begin
			open c01;
			loop
			fetch c01 into
				nr_seq_aut_cancel_w;
			EXIT WHEN NOT FOUND; /* apply on c01 */
				begin
				CALL atualizar_autorizacao_convenio(nr_seq_aut_cancel_w, nm_usuario_p, nr_seq_estagio_cancel_w, 'N', 'N', 'S');
				end;
			end loop;
			close c01;
			end;
		end if;
		end;
	end if;

	ie_atualiza_estagio_aut_w := Obter_Param_Usuario(820, 157, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_atualiza_estagio_aut_w);
	if (ie_atualiza_estagio_aut_w = 'S') then
		begin
		select	max(nr_sequencia)
		into STRICT	nr_seq_estagio_autor_w
		from	estagio_autorizacao
		where	ie_situacao = 'A'
		and	ie_autor_agenda = ie_autorizacao_p
		and	OBTER_EMPRESA_ESTAB(wheb_usuario_pck.get_cd_estabelecimento) = cd_empresa;

		if (nr_seq_estagio_autor_w > 0) then
			begin
			open c02;
			loop
			fetch c02 into
				nr_seq_autorizacao_w;
			EXIT WHEN NOT FOUND; /* apply on c02 */
				begin
				CALL atualizar_autorizacao_convenio(nr_seq_autorizacao_w, nm_usuario_p, nr_seq_estagio_autor_w, 'N', 'N', 'S');
				end;
			end loop;
			close c02;
			end;
		end if;
		end;
	end if;

	CALL gerar_autor_regra(null, null, null, null, null,	null, 'AP', nm_usuario_p, nr_seq_agenda_p, nr_seq_proc_interno_p, null, null, null, null,'','','');

	begin
	ds_retorno_w := consistir_gerar_autor_agrup(nr_seq_agenda_p, 'AP', nm_usuario_p, ds_retorno_w);
	exception
	when others then
		ds_erro_w := Wheb_mensagem_pck.get_texto(307476) || ' '; --'Gerou erro ao agrupar a autorização do convênio ';
	end;
	end;
end if;

ds_retorno_p	:= ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE agenda_paciente_afterpost_js ( nr_seq_agenda_p bigint, cd_procedimento_p bigint, nr_seq_proc_interno_p bigint, cd_convenio_p bigint, ie_autorizacao_p text, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, ds_retorno_p INOUT text) FROM PUBLIC;
