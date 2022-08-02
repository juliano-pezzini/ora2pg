-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_benef_preexistencia ( nr_seq_segurado_p bigint, nr_seq_beneficiario_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_tipo_carencia_w		bigint;
dt_final_w			timestamp;
dt_adesao_w			timestamp;
cd_doenca_cid_w			varchar(10);
qt_registros_w			bigint;
cd_categoria_cid_w		varchar(10);

c01 CURSOR FOR
	SELECT	nr_seq_tipo_carencia,
		(coalesce(dt_inicio_vigencia,dt_adesao_w) + qt_dias)
	from	pls_carencia
	where	nr_seq_segurado	= nr_seq_segurado_p
	and	ie_cpt		= 'S';

C02 CURSOR FOR
	SELECT	b.cd_doenca_cid
	from	pls_carencia_proc	b,
		pls_tipo_carencia	a
	where	b.nr_seq_tipo_carencia	= a.nr_sequencia
	and	a.nr_sequencia		= nr_seq_tipo_carencia_w
	and	(b.cd_doenca_cid IS NOT NULL AND b.cd_doenca_cid::text <> '');


BEGIN

select	dt_contratacao
into STRICT	dt_adesao_w
from	pls_segurado
where	nr_sequencia	= nr_seq_segurado_p;

open c01;
loop
fetch c01 into
	nr_seq_tipo_carencia_w,
	dt_final_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	open C02;
	loop
	fetch C02 into
		cd_doenca_cid_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		/*aaschlote 30/06/2011 - OS - 327957 - Conforme visto com o paulo da unimed, deve ir a categoria do cid no arquivo*/

		select	max(cd_categoria_cid)
		into STRICT	cd_categoria_cid_w
		from  	cid_doenca
		where 	cd_doenca_cid	 = cd_doenca_cid_w;

		begin
		select	count(*)
		into STRICT	qt_registros_w
		from	ptu_benef_preexistencia
		where	nr_seq_beneficiario	= nr_seq_beneficiario_p
		and	cd_cid			= cd_categoria_cid_w;
		exception
		when others then
			qt_registros_w	:= 0;
		end;

		if (qt_registros_w	= 0) then
			insert into ptu_benef_preexistencia(	nr_sequencia, nr_seq_beneficiario, cd_cid,
				dt_fim_carencia, dt_atualizacao, nm_usuario,
				dt_atualizacao_nrec, nm_usuario_nrec)
			values (	nextval('ptu_benef_preexistencia_seq'), nr_seq_beneficiario_p, cd_categoria_cid_w,
				dt_final_w, clock_timestamp(), nm_usuario_p,
				clock_timestamp(), nm_usuario_p);
		end if;

		end;
	end loop;
	close C02;

	end;
end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_benef_preexistencia ( nr_seq_segurado_p bigint, nr_seq_beneficiario_p bigint, nm_usuario_p text) FROM PUBLIC;

