-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_transf_pront_barras ( cd_seq_transf_p bigint, ds_msg_erro_p INOUT text, nm_usuario_p text) AS $body$
DECLARE


ie_cont_transf_solic_w	varchar(10);
ie_atend_transf_w	varchar(10);
ie_forma_consist_pront_w	varchar(10);
qt_exame_receb_w	bigint;
nr_atendimento_w	bigint;
cd_pessoa_fisica_w	varchar(10);
ds_msg_erro_w		varchar(2000) := '';

BEGIN
if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin

	ie_cont_transf_solic_w := obter_Param_Usuario(941, 53, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_cont_transf_solic_w);
	ie_atend_transf_w := obter_Param_Usuario(941, 100, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_atend_transf_w);
	ie_forma_consist_pront_w := obter_Param_Usuario(0, 120, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_forma_consist_pront_w);

	if (ie_cont_transf_solic_w = 'S') then
		begin
		
		select	count(*)
		into STRICT	qt_exame_receb_w
		from	same_prontuario a,
			transf_prontuario b,
			transf_prontuario_envelope c
		where	a.nr_sequencia = c.nr_seq_prontuario
		and	c.nr_seq_transf = b.nr_sequencia
		and	coalesce(dt_recebimento::text, '') = ''
		and	a.nr_sequencia = cd_seq_transf_p;
		
		if (qt_exame_receb_w > 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(130077);
		end if;

		end;
	else
		begin
		if (ie_atend_transf_w = 'N') then
			begin
			select	max(nr_atendimento), max(cd_pessoa_fisica)
			into STRICT	nr_atendimento_w, cd_pessoa_fisica_w
			from	same_prontuario
			where 	nr_sequencia = cd_seq_transf_p;
			end;
		elsif (ie_atend_transf_w = 'P') then
			begin
			if (ie_forma_consist_pront_w <> 'ESTAB') then
				begin
				select	max(a.nr_atendimento), max(a.cd_pessoa_fisica)
				into STRICT	nr_atendimento_w, cd_pessoa_fisica_w
				from	same_prontuario a, pessoa_fisica b
				where 	a.cd_pessoa_fisica = b.cd_pessoa_fisica
				and	b.nr_prontuario = cd_seq_transf_p;
				end;
			else
				begin
				select max(a.nr_atendimento),max(a.cd_pessoa_fisica)
				into STRICT nr_atendimento_w, cd_pessoa_fisica_w
				from	same_prontuario a,
					pessoa_fisica b,
					pessoa_fisica_pront_estab c
				where	a.cd_pessoa_fisica		= b.cd_pessoa_fisica
				and	b.cd_pessoa_fisica		= c.cd_pessoa_fisica
				and	c.cd_estabelecimento	= a.cd_estabelecimento
				and	c.nr_prontuario		= cd_seq_transf_p;
				end;
			end if;
			end;
		else
			begin
			select	max(nr_atendimento), max(cd_pessoa_fisica)
			into STRICT	nr_atendimento_w, cd_pessoa_fisica_w
			from	same_prontuario
			where 	nr_atendimento = cd_seq_transf_p;
			end;
		end if;
		
		CALL consiste_pront_transf_pendente(cd_pessoa_fisica_w, nr_atendimento_w, null);
		end;
	end if;

	ds_msg_erro_w := obter_texto_dic_objeto(130090, wheb_usuario_pck.get_nr_seq_idioma, null);
	end;
end if;
ds_msg_erro_p	:= ds_msg_erro_w;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_transf_pront_barras ( cd_seq_transf_p bigint, ds_msg_erro_p INOUT text, nm_usuario_p text) FROM PUBLIC;
