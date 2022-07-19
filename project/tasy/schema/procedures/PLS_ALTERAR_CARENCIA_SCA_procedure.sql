-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_carencia_sca ( nr_seq_segurado_p bigint, nr_seq_carencia_p bigint, dt_inicio_vigencia_p timestamp, qt_dias_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_carencia_benef_w	integer;


BEGIN

select	count(1)
into STRICT	qt_carencia_benef_w
from	pls_carencia
where	nr_sequencia = nr_seq_carencia_p
and	nr_seq_segurado = nr_seq_segurado_p;

if (qt_carencia_benef_w > 0) then
	update	pls_carencia
	set	dt_inicio_vigencia = dt_inicio_vigencia_p,
		qt_dias = qt_dias_p,
		dt_fim_vigencia  = NULL,
		dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_seq_carencia_p;
else --Se não existir a carência para o beneficiário, então insere
	insert	into	pls_carencia(	nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_segurado,
			dt_inicio_vigencia,
			qt_dias,
			nr_seq_grupo_carencia,
			nr_seq_tipo_carencia,
			ds_observacao,
			ie_origem_carencia_benef,
			ie_carencia_anterior)
	(	SELECT	nextval('pls_carencia_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_segurado_p,
			dt_inicio_vigencia_p,
			qt_dias_p,
			nr_seq_grupo_carencia,
			nr_seq_tipo_carencia,
			'Carência alterada pelo usuário',
			'S',
			'N'
		from	pls_carencia
		where	nr_sequencia	= nr_seq_carencia_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_carencia_sca ( nr_seq_segurado_p bigint, nr_seq_carencia_p bigint, dt_inicio_vigencia_p timestamp, qt_dias_p bigint, nm_usuario_p text) FROM PUBLIC;

