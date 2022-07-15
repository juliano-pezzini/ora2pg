-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_sup_int_marca ( nr_sequencia_p bigint, cd_cnpj_fabricante_p text, nr_seq_tipo_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_existe_fabricante_w		bigint;
qt_existe_tipo_marca_w		bigint;
nr_inconsistencia_w		integer;


BEGIN

delete 	from sup_int_marca_consist
where	nr_sequencia = nr_sequencia_p
and	ie_integracao = '2';

select 	count(*)
into STRICT	qt_existe_fabricante_w
from 	pessoa_juridica
where 	cd_sistema_ant = cd_cnpj_fabricante_p;

select 	count(*)
into STRICT	qt_existe_tipo_marca_w
from 	tipo_marca
where	cd_sistema_ant = nr_seq_tipo_p;

if (qt_existe_fabricante_w = 0) then

	select	coalesce(max(nr_inconsistencia),0) + 1
	into STRICT	nr_inconsistencia_w
	from	sup_int_marca_consist
	where	nr_sequencia = nr_sequencia_p
	and	ie_integracao = '2';

	insert into sup_int_marca_consist(
		nr_sequencia,
		nr_inconsistencia,
		ds_mensagem,
		ie_integracao,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec)
	values (	nr_sequencia_p,
		nr_inconsistencia_w,
		wheb_mensagem_pck.get_texto(1043543),
		2,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p);

end if;

if (qt_existe_tipo_marca_w = 0) then

	select	coalesce(max(nr_inconsistencia),0) + 1
	into STRICT	nr_inconsistencia_w
	from	sup_int_marca_consist
	where	nr_sequencia = nr_sequencia_p
	and	ie_integracao = '2';

	insert into sup_int_marca_consist(
		nr_sequencia,
		nr_inconsistencia,
		ds_mensagem,
		ie_integracao,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec)
	values (	nr_sequencia_p,
		nr_inconsistencia_w,
		wheb_mensagem_pck.get_texto(1043544),
		2,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p);

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_sup_int_marca ( nr_sequencia_p bigint, cd_cnpj_fabricante_p text, nr_seq_tipo_p bigint, nm_usuario_p text) FROM PUBLIC;

