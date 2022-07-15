-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_email_regra_alta ( nr_atendimento_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_regras_w				bigint;
ds_assunto_w			varchar(255);
ds_mensagem_padrao_w	varchar(4000);
ds_email_destino_w		varchar(80);
ds_email_origem_w		varchar(60);
ds_setor_w				varchar(80);
dt_alta_w				timestamp;
nm_paciente_w			varchar(80);
nm_medico_resp_w		varchar(80);
cd_pessoa_fisica_w		varchar(15);
cd_setor_regra_w		bigint;
cd_setor_paciente_w		bigint;
cd_setor_usuario_w		bigint;

c01 CURSOR FOR
	SELECT	ds_remetente,
			ds_titulo,
			ds_email,
			cd_setor_atendimento,
			cd_setor_usuario
	from	regra_email_alta
	where	((coalesce(cd_estabelecimento::text, '') = '') or (cd_estabelecimento = cd_estabelecimento_p))
	and		coalesce(ie_situacao,'I') = 'A'
	order by 1;


BEGIN

select	count(*)
into STRICT	nr_regras_w
from 	regra_email_alta
where ((coalesce(cd_estabelecimento::text, '') = '') or (cd_estabelecimento = cd_estabelecimento_p))
and		coalesce(ie_situacao,'I') = 'A';

if (nr_regras_w > 0) then
	begin
	if (nr_atendimento_p > 0) then

		select	cd_pessoa_fisica,
				substr(obter_nome_pf(cd_pessoa_fisica),1,80),
				dt_alta,
				substr(obter_dados_atendimento(nr_atendimento,'MR'),1,80),
				substr(Obter_Unidade_Atendimento(nr_atendimento,'A','CS'),1,5)
		into STRICT	cd_pessoa_fisica_w,
				nm_paciente_w,
				dt_alta_w,
				nm_medico_resp_w,
				cd_setor_paciente_w
		from	atendimento_paciente
		where	cd_estabelecimento 	= cd_estabelecimento_p
		and		nr_atendimento 		= nr_atendimento_p;

		ds_setor_w := substr(obter_nome_setor(cd_setor_paciente_w),1,80);

		select	ds_email
		into STRICT	ds_email_destino_w
		from	compl_pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_w
		and		ie_tipo_complemento = 1;

		if (coalesce(ds_email_destino_w,'X') <> 'X')	then
			open C01;
			loop
			fetch C01 into
				ds_email_origem_w,
				ds_assunto_w,
				ds_mensagem_padrao_w,
				cd_setor_regra_w,
				cd_setor_usuario_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin
				if (coalesce(cd_setor_regra_w, cd_setor_paciente_w ) = cd_setor_paciente_w) and
					((coalesce(cd_setor_usuario_w::text, '') = '') or (cd_setor_usuario_w = wheb_usuario_pck.get_cd_setor_atendimento)) then

					ds_mensagem_padrao_w	:= substr(replace_macro(ds_mensagem_padrao_w,'@setor',ds_setor_w), 1, 4000);
					ds_mensagem_padrao_w	:= substr(replace_macro(ds_mensagem_padrao_w,'@paciente',nm_paciente_w), 1, 4000);
					ds_mensagem_padrao_w	:= substr(replace_macro(ds_mensagem_padrao_w,'@data_alta',dt_alta_w), 1, 4000);
					ds_mensagem_padrao_w	:= substr(replace_macro(ds_mensagem_padrao_w,'@medico',nm_medico_resp_w), 1, 4000);
					ds_mensagem_padrao_w	:= substr(replace_macro(ds_mensagem_padrao_w,'@atendimento',nr_atendimento_p), 1, 4000);

					CALL enviar_email(
						ds_assunto_w,
						ds_mensagem_padrao_w,
						ds_email_origem_w,
						ds_email_destino_w,
						nm_usuario_p,
						'M');
				end if;
				end;
			end loop;
			close C01;
		end if;
	end if;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_email_regra_alta ( nr_atendimento_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

