-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_inserir_etapa_ofic_funcao ( nr_seq_ofic_uso_p bigint, nr_seq_etapa_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w	bigint;
nr_seq_etapa_w	bigint;
nr_seq_mod_impl_w		bigint;
nr_seq_func_w	bigint;
cd_funcao_w		bigint;
qt_modulo_count_w		bigint;

C01 CURSOR FOR
	SELECT	a.cd_funcao
	from	funcao	a
	where	a.ie_situacao	=	'A'
	and		a.nr_seq_mod_impl	=	nr_seq_mod_impl_w
	and		not	exists (	SELECT	1
							from	com_cli_ofic_uso_mod_func	x
							where	x.cd_funcao	=	a.cd_funcao
							and		x.nr_seq_mod_ofic_uso	=	nr_sequencia_w);


BEGIN

nr_seq_etapa_w	:=		nr_seq_etapa_p;
if (coalesce(nr_seq_etapa_w,0)	<>	0)	then
	select	coalesce(max(nr_seq_mod_impl),0)
	into STRICT	nr_seq_mod_impl_w
	from	proj_etapa_cronograma
	where	nr_sequencia	=	nr_seq_etapa_w;
end	if;

if (coalesce(nr_seq_mod_impl_w,0)	<>	0)	then
	select	nextval('com_cli_ofic_uso_mod_seq')
	into STRICT	nr_sequencia_w
	;

	select	count(*)
	into STRICT	qt_modulo_count_w
	from	modulo_implantacao	b
	where	b.nr_sequencia	=	nr_seq_mod_impl_w;

	if (qt_modulo_count_w	=	0)	then
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(352664);
	end	if;

	insert	into	com_cli_ofic_uso_mod(
		nr_sequencia,
		nr_seq_ofic,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_mod_impl,
		nr_seq_etapa)
	values (	nr_sequencia_w,
		nr_seq_ofic_uso_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_mod_impl_w,
		nr_seq_etapa_w);

	open	C01;
	loop
		fetch	C01	into
			cd_funcao_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
			select	nextval('com_cli_ofic_uso_mod_func_seq')
			into STRICT	nr_seq_func_w
			;

			insert	into	com_cli_ofic_uso_mod_func(
				nr_sequencia,
				nr_seq_mod_ofic_uso,
				cd_funcao,
				dt_atualizacao,
				nm_usuario)
			values (	nr_seq_func_w,
				nr_sequencia_w,
				cd_funcao_w,
				clock_timestamp(),
				nm_usuario_p);
		end;
	end	loop;
	close	C01;
end if;
commit;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_inserir_etapa_ofic_funcao ( nr_seq_ofic_uso_p bigint, nr_seq_etapa_p text, nm_usuario_p text) FROM PUBLIC;
