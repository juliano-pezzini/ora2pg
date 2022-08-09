-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_migrar_cpt_benef ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_segurado_ant_w		bigint;
qt_registros_w			bigint;
dt_inclusao_operadora_w		timestamp;

C01 CURSOR FOR
	SELECT	nr_sequencia nr_seq_carencia,
		nr_seq_tipo_carencia,
		qt_dias
	from	pls_carencia
	where	nr_seq_segurado	= nr_seq_segurado_ant_w
	and	ie_cpt		= 'S';

BEGIN

select	nr_seq_segurado_ant
into STRICT	nr_seq_segurado_ant_w
from	pls_segurado
where	nr_sequencia	= nr_seq_segurado_p;

select	dt_inclusao_operadora
into STRICT	dt_inclusao_operadora_w
from	pls_segurado
where	nr_sequencia	= nr_seq_segurado_ant_w;

for r_c01_w in C01 loop
	begin
	
	select	count(1)
	into STRICT	qt_registros_w
	from	pls_carencia
	where	nr_seq_segurado		= nr_seq_segurado_p
	and	nr_seq_tipo_carencia	= r_c01_w.nr_seq_tipo_carencia  LIMIT 1;
	
	if	((dt_inclusao_operadora_w+r_c01_w.qt_dias) > clock_timestamp()) and (qt_registros_w = 0) then
		insert into pls_carencia(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
				nr_seq_tipo_carencia,nr_seq_segurado,dt_inicio_vigencia,qt_dias,ds_observacao,
				ie_cpt,ie_origem_carencia_benef, dt_fim_vigencia)
			(SELECT	nextval('pls_carencia_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
				nr_seq_tipo_carencia,nr_seq_segurado_p,dt_inclusao_operadora_w,qt_dias,'CPT incluido no beneficiário através da migração de contratos',
				'S','P', (dt_inclusao_operadora_w + r_c01_w.qt_dias)
			from	pls_carencia
			where	nr_sequencia	= r_c01_w.nr_seq_carencia);
	end if;	
	
	end;
end loop; --C01
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_migrar_cpt_benef ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
