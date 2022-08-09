-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_benef_carencia ( nr_seq_segurado_p bigint, nr_seq_beneficiario_p bigint, dt_mov_final_p timestamp, nm_usuario_p text) AS $body$
DECLARE



nr_seq_tipo_carencia_w		bigint;
dt_final_w			timestamp;
dt_adesao_w			timestamp;
cd_ptu_carencia_w		varchar(3);
qt_registros_w			bigint;
dt_fim_vigencia_atual_w		timestamp;
nr_seq_plano_w			bigint;

c01 CURSOR FOR
	SELECT	b.nr_seq_tipo_carencia,
		(coalesce(b.dt_inicio_vigencia,dt_adesao_w) + qt_dias)
	from	pls_carencia	b,
		pls_segurado	a
	where	b.nr_seq_segurado	= a.nr_sequencia
	and	a.nr_sequencia		= nr_seq_segurado_p
	and	b.ie_cpt		= 'N'
	and	pls_consistir_sexo_carencia(a.nr_sequencia,b.nr_seq_tipo_carencia) = 'S'
	
union

	SELECT	b.nr_seq_tipo_carencia,
		(coalesce(b.dt_inicio_vigencia,dt_adesao_w) + qt_dias)
	from	pls_plano	c,
		pls_carencia	b,
		pls_segurado	a
	where	b.nr_seq_plano	= c.nr_sequencia
	and	a.nr_seq_plano	= c.nr_sequencia
	and	a.nr_sequencia	= nr_seq_segurado_p
	and	c.nr_sequencia		= nr_seq_plano_w
	and	ie_cpt			= 'N'
	and	pls_consistir_sexo_carencia(a.nr_sequencia,b.nr_seq_tipo_carencia) = 'S'
	and	not exists (	select	1
					from	pls_carencia	x
					where	x.nr_seq_segurado	= a.nr_sequencia
					and	x.ie_cpt		= 'N');


BEGIN

select	coalesce(dt_inclusao_operadora,dt_contratacao),
	nr_seq_plano
into STRICT	dt_adesao_w,
	nr_seq_plano_w
from	pls_segurado
where	nr_sequencia	= nr_seq_segurado_p;

open c01;
loop
fetch c01 into
	nr_seq_tipo_carencia_w,
	dt_final_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	if (trunc(dt_final_w,'dd') >= trunc(coalesce(dt_mov_final_p, dt_final_w),'dd')) then
		begin
		select	cd_ptu
		into STRICT	cd_ptu_carencia_w
		from	pls_tipo_carencia
		where	nr_sequencia	= nr_seq_tipo_carencia_w;
		exception
		when others then
			cd_ptu_carencia_w	:= null;
		end;

		/*Verificar se existe código do PTU na carência*/

		if (cd_ptu_carencia_w IS NOT NULL AND cd_ptu_carencia_w::text <> '') then
			/*Verificar se a carência já está no beneficiário do envio do repasse*/

			select	count(*)
			into STRICT	qt_registros_w
			from	ptu_beneficiario_carencia
			where	nr_seq_beneficiario	= nr_seq_beneficiario_p
			and	cd_tipo_cobertura	= cd_ptu_carencia_w;

			/*Caso não estiver, intão inclui a carência para o repasse*/

			if (qt_registros_w	= 0) then
				insert into ptu_beneficiario_carencia(nr_sequencia, nr_seq_beneficiario, cd_tipo_cobertura,
					dt_fim_carencia, dt_atualizacao, nm_usuario,
					dt_atualizacao_nrec, nm_usuario_nrec)
				values (nextval('ptu_beneficiario_carencia_seq'), nr_seq_beneficiario_p, cd_ptu_carencia_w,
					dt_final_w, clock_timestamp(), nm_usuario_p,
					clock_timestamp(), nm_usuario_p);
			else
				/*Se estiver, verifica se a dt vigencia que está no repasse é menor do que está passado no cursor*/

				select	max(dt_fim_carencia)
				into STRICT	dt_fim_vigencia_atual_w
				from	ptu_beneficiario_carencia
				where	nr_seq_beneficiario	= nr_seq_beneficiario_p
				and	cd_tipo_cobertura	= cd_ptu_carencia_w;

				if (dt_final_w	> dt_fim_vigencia_atual_w) then
					update	ptu_beneficiario_carencia
					set	dt_fim_carencia	= dt_final_w
					where	nr_seq_beneficiario	= nr_seq_beneficiario_p
					and	cd_tipo_cobertura	= cd_ptu_carencia_w;
				end if;
			end if;
		end if;
	end if;
	end;
end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_benef_carencia ( nr_seq_segurado_p bigint, nr_seq_beneficiario_p bigint, dt_mov_final_p timestamp, nm_usuario_p text) FROM PUBLIC;
