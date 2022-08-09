-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE envia_alerta_alteracao_tabela ( nm_tabela_p text, ie_tipo_alteracao_p text, nm_usuario_p text ) AS $body$
DECLARE


ds_alerta_w		varchar(4000);
ds_tipo_alt_w		varchar(1000);
ds_tabela_w		varchar(500);


BEGIN

if (ie_tipo_alteracao_p = 'A') then
	ds_tipo_alt_w := 'alteração';
elsif (ie_tipo_alteracao_p = 'E') then
	ds_tipo_alt_w := 'exclusão';
elsif (ie_tipo_alteracao_p = 'I') then
	ds_tipo_alt_w := 'inserção';
end if;

if (coalesce(ie_tipo_alteracao_p,'X') <> 'X') then
begin
	select	a.ds_tabela
	into STRICT	ds_tabela_w
	from	tabela_sistema a
	where	a.nm_tabela = nm_tabela_p;

	ds_alerta_w := 'Tabela ' || nm_tabela_p || ' - ' || ds_tabela_w || ', realizada uma' || ds_tipo_alt_w || ' na tela "Cadastros gerais", pelo usuário ' || nm_usuario_p;

	insert	into alerta_alteracao_tabela(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ds_alerta,
		nm_tabela,
		ie_tipo_alteracao)
	values (nextval('alerta_alteracao_tabela_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		ds_alerta_w,
		nm_tabela_p,
		ie_tipo_alteracao_p);
end;
end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE envia_alerta_alteracao_tabela ( nm_tabela_p text, ie_tipo_alteracao_p text, nm_usuario_p text ) FROM PUBLIC;
