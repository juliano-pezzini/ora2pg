-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_regra_consulta_contato ( nm_usuario_p text, lista_perfil_p text, cd_estabelecimento_p bigint, cd_pessoa_p text) AS $body$
DECLARE


lista_perfil_w		varchar(4000);
ie_contador_w		bigint	:= 0;
ie_pos_virgula_w	smallint;
cd_perfil_w		integer;
nr_seq_regra_consul_w	bigint;
nr_sequencia_w		bigint;
tam_lista_w		bigint;
qt_perfil_existente_w   bigint;



BEGIN
if (cd_pessoa_p IS NOT NULL AND cd_pessoa_p::text <> '') then
	begin
	select  max(nr_sequencia)
	into STRICT	nr_seq_regra_consul_w
	from	regra_consulta_contato
	where	cd_pessoa_fisica = cd_pessoa_p;
	end;
end if;

if (coalesce(nr_seq_regra_consul_w::text, '') = '') and (cd_pessoa_p IS NOT NULL AND cd_pessoa_p::text <> '') then
	begin
	select	nextval('regra_consulta_contato_seq')
	into STRICT	nr_seq_regra_consul_w
	;

	insert into regra_consulta_contato(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		cd_pessoa_fisica)
	values (
		nr_seq_regra_consul_w,
		clock_timestamp(),
		nm_usuario_p,
		cd_pessoa_p);
	end;
end if;

cd_perfil_w	:= null;
lista_perfil_w	:= lista_perfil_p;

while	(lista_perfil_w IS NOT NULL AND lista_perfil_w::text <> '') loop
	begin
	tam_lista_w		:= length(lista_perfil_w);
	ie_pos_virgula_w	:= position(',' in lista_perfil_w);

	if (ie_pos_virgula_w <> 0) then
		begin
		cd_perfil_w	:= substr(lista_perfil_w,1,(ie_pos_virgula_w - 1));
		lista_perfil_w	:= substr(lista_perfil_w,(ie_pos_virgula_w + 1),tam_lista_w);
		end;
	end if;

	SELECT coalesce(count(*),0)
	into STRICT   qt_perfil_existente_w
	FROM   regra_consulta_contato a
	WHERE  a.nr_sequencia = nr_seq_regra_consul_w
	AND    EXISTS ( SELECT  1
	   		FROM   regra_consulta_contato_lib x
			WHERE  x.nr_seq_regra_consulta = a.nr_sequencia
			AND    x.cd_perfil = cd_perfil_w);


	if ( nr_seq_regra_consul_w > 0) and (qt_perfil_existente_w = 0) then
		begin
		select	nextval('regra_consulta_contato_lib_seq')
		into STRICT	nr_sequencia_w
		;

		insert into regra_consulta_contato_lib(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			nr_seq_regra_consulta,
			cd_perfil,
			cd_pessoa_fisica,
			ie_permite_visualizar_contato)
		values (
			nr_sequencia_w,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_regra_consul_w,
			cd_perfil_w,
			'',
			'S');
		end;

	end if;

	end;
end loop;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_regra_consulta_contato ( nm_usuario_p text, lista_perfil_p text, cd_estabelecimento_p bigint, cd_pessoa_p text) FROM PUBLIC;
