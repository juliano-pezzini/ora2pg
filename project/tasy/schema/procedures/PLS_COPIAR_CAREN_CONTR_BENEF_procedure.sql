-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_copiar_caren_contr_benef ( nr_seq_contrato_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_segurado_w	bigint;
dt_adesao_segurado_w	timestamp;
nr_seq_carencia_w	bigint;
nr_seq_tipo_carencia_w	bigint;
qt_dias_w		bigint;
dt_fim_vigencia_w	timestamp;
ds_observacao_w		varchar(255);
nr_seq_grupo_carencia_w	bigint;
qt_carencias_w		bigint;
nr_seq_plano_w		bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_plano
	from	pls_segurado
	where	nr_seq_contrato	= nr_seq_contrato_p;

C02 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_carencia
	where	nr_seq_contrato	= nr_seq_contrato_p
	and	((nr_seq_plano_contrato = nr_seq_plano_w) or (coalesce(nr_seq_plano_contrato::text, '') = ''));


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_segurado_w,
	nr_seq_plano_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select	dt_contratacao
	into STRICT	dt_adesao_segurado_w
	from	pls_segurado
	where	nr_sequencia	= nr_seq_segurado_w;

	open C02;
	loop
	fetch C02 into
		nr_seq_carencia_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		select	nr_seq_tipo_carencia,
			qt_dias,
			nr_seq_grupo_carencia
		into STRICT	nr_seq_tipo_carencia_w,
			qt_dias_w,
			nr_seq_grupo_carencia_w
		from	pls_carencia
		where	nr_sequencia	= nr_seq_carencia_w;

		if (nr_seq_tipo_carencia_w IS NOT NULL AND nr_seq_tipo_carencia_w::text <> '') then
			select	count(*)
			into STRICT	qt_carencias_w
			from	pls_carencia
			where	nr_seq_tipo_carencia	= nr_seq_tipo_carencia_w
			and	nr_seq_segurado		= nr_seq_segurado_w;
		elsif (nr_seq_grupo_carencia_w IS NOT NULL AND nr_seq_grupo_carencia_w::text <> '') then
			select	count(*)
			into STRICT	qt_carencias_w
			from	pls_carencia
			where	nr_seq_grupo_carencia	= nr_seq_grupo_carencia_w
			and	nr_seq_segurado		= nr_seq_segurado_w;
		end if;

		if (qt_carencias_w = 0) then
			/*aaschlote OS - 279915*/

			if (pls_consistir_sexo_carencia(nr_seq_segurado_w,nr_seq_tipo_carencia_w) = 'S') then
				dt_fim_vigencia_w	:= dt_adesao_segurado_w + qt_dias_w;
				ds_observacao_w		:= 'Gerado a partir da pasta Regras/Carência';

				insert into pls_carencia(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
						nr_seq_segurado,nr_seq_tipo_carencia,qt_dias,dt_inicio_vigencia,dt_fim_vigencia,
						ds_observacao,ie_origem_carencia_benef,nr_seq_grupo_carencia,ie_cpt)
				values (	nextval('pls_carencia_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
						nr_seq_segurado_w,nr_seq_tipo_carencia_w,qt_dias_w,dt_adesao_segurado_w,dt_fim_vigencia_w,
						ds_observacao_w,'P',nr_seq_grupo_carencia_w,'N');
			end if;
		end if;
		end;
	end loop;
	close C02;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_copiar_caren_contr_benef ( nr_seq_contrato_p bigint, nm_usuario_p text) FROM PUBLIC;

