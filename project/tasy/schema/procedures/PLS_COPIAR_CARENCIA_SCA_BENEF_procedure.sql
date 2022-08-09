-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_copiar_carencia_sca_benef ( nr_seq_segurado_p bigint, qt_dias_p bigint, ie_isentar_carencia_p text, ie_commit_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_plano_sca_w		bigint;
nr_seq_tipo_carencia_w		bigint;
qt_dias_w			bigint;
dt_inicio_vigencia_w		timestamp;
qt_registros_w			bigint;
nr_seq_grupo_carencia_w		bigint;
ie_permite_isencao_carencia_w	pls_plano.ie_permite_isencao_carencia%type;
ie_copiar_carencias_sca_w	varchar(1);

C01 CURSOR FOR
	SELECT	a.nr_seq_plano,
		coalesce(a.dt_inclusao_benef,a.dt_inicio_vigencia),
		coalesce(ie_permite_isencao_carencia,'S')
	from	pls_sca_vinculo	a,
		pls_plano	b
	where	a.nr_seq_plano		= b.nr_sequencia
	and	a.nr_seq_segurado	= nr_seq_segurado_p;

C02 CURSOR FOR
	SELECT	nr_seq_tipo_carencia,
		nr_seq_grupo_carencia,
		qt_dias
	from	pls_carencia
	where	nr_seq_plano = nr_seq_plano_sca_w
	and	dt_inicio_vigencia_w between coalesce(dt_inicio_vig_plano,dt_inicio_vigencia_w) and coalesce(dt_fim_vig_plano,dt_inicio_vigencia_w);


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_plano_sca_w,
	dt_inicio_vigencia_w,
	ie_permite_isencao_carencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ie_copiar_carencias_sca_w	:= 'S';

	if (ie_isentar_carencia_p = 'S') and (ie_permite_isencao_carencia_w = 'N') then
		ie_copiar_carencias_sca_w	:= 'N';
	end if;

	if (ie_copiar_carencias_sca_w = 'S') then
		open C02;
		loop
		fetch C02 into
			nr_seq_tipo_carencia_w,
			nr_seq_grupo_carencia_w,
			qt_dias_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			if (nr_seq_tipo_carencia_w IS NOT NULL AND nr_seq_tipo_carencia_w::text <> '') then
				select	count(1)
				into STRICT	qt_registros_w
				from	pls_carencia
				where	nr_seq_segurado		= nr_seq_segurado_p
				and	nr_seq_tipo_carencia	= nr_seq_tipo_carencia_w;
			elsif (nr_seq_grupo_carencia_w IS NOT NULL AND nr_seq_grupo_carencia_w::text <> '') then
				select	count(1)
				into STRICT	qt_registros_w
				from	pls_carencia
				where	nr_seq_segurado		= nr_seq_segurado_p
				and	nr_seq_grupo_carencia	= nr_seq_grupo_carencia_w;
			end if;

			/*aaschlote OS - 279915*/

			if (pls_consistir_sexo_carencia(nr_seq_segurado_p,nr_seq_tipo_carencia_w) = 'S') then
				if (qt_registros_w = 0) then
					insert	into pls_carencia(	nr_sequencia,dt_atualizacao, nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
							nr_seq_segurado, dt_inicio_vigencia, qt_dias,nr_seq_grupo_carencia,
							nr_seq_tipo_carencia,ds_observacao,ie_origem_carencia_benef,ie_carencia_anterior)
					values (	nextval('pls_carencia_seq'), clock_timestamp(), nm_usuario_p,clock_timestamp(), nm_usuario_p,
							nr_seq_segurado_p, dt_inicio_vigencia_w, CASE WHEN qt_dias_p=-1 THEN qt_dias_w  ELSE qt_dias_p END ,nr_seq_grupo_carencia_w,
							nr_seq_tipo_carencia_w,'Origem: Copia da carência na isenção de carência','S','N');
				end if;
			end if;
			end;
		end loop;
		close C02;
	end if;
	end;
end loop;
close C01;

if (ie_commit_p = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_copiar_carencia_sca_benef ( nr_seq_segurado_p bigint, qt_dias_p bigint, ie_isentar_carencia_p text, ie_commit_p text, nm_usuario_p text) FROM PUBLIC;
