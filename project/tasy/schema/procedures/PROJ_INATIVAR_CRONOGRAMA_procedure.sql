-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_inativar_cronograma ( nr_seq_cronograma_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_projeto_w	bigint;
nr_seq_cliente_w	bigint;
nr_seq_projeto_w	bigint;


BEGIN

select	count(*)
into STRICT	qt_projeto_w
from	proj_cronograma c,
	proj_projeto p
where	p.nr_sequencia = c.nr_seq_proj
and	c.nr_sequencia = nr_seq_cronograma_p;

if (qt_projeto_w > 0) then

	select	max(p.nr_seq_cliente),
		max(p.nr_sequencia)
	into STRICT	nr_seq_cliente_w,
		nr_seq_projeto_w
	from	proj_cronograma c,
		proj_projeto p
	where	p.nr_sequencia = c.nr_seq_proj
	and	c.nr_sequencia = nr_seq_cronograma_p;

	update	proj_cronograma
	set	ie_situacao = 'I'
	where	nr_sequencia = nr_seq_cronograma_p;

	insert into com_cliente_hist(
		nr_sequencia,
		nr_seq_projeto,
		nr_seq_cliente,
		nr_seq_tipo,
		dt_historico,
		nm_usuario,
		dt_atualizacao,
		ds_titulo,
		dt_liberacao,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ds_historico)
	values (	nextval('com_cliente_hist_seq'),
		nr_seq_projeto_w,
		nr_seq_cliente_w,
		8,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		'Inativação de cronograma',
		clock_timestamp(),
		clock_timestamp(),
		nm_usuario_p,
		'O cronograma '||nr_seq_cronograma_p|| ' foi inativado.');
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_inativar_cronograma ( nr_seq_cronograma_p bigint, nm_usuario_p text) FROM PUBLIC;

