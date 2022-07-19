-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_ajustar_segurado_estab () AS $body$
DECLARE


nr_seq_segurado_w	bigint;
cd_estab_contrato_w	bigint;
cd_estab_plano_w	bigint;
cd_estab_intercambio_w	bigint;
cd_estab_congenere_w	bigint;
ie_tipo_segurado_w	varchar(2);
cd_estab_pericia_w	bigint;

C01 CURSOR FOR
	SELECT	a.cd_estabelecimento,
		b.nr_sequencia,
		c.cd_estabelecimento,
		b.ie_tipo_segurado,
		d.cd_estabelecimento,
		e.cd_estabelecimento
	FROM pls_segurado b
LEFT OUTER JOIN pls_contrato a ON (b.nr_seq_contrato = a.nr_sequencia)
LEFT OUTER JOIN pls_plano c ON (b.nr_seq_plano = c.nr_sequencia)
LEFT OUTER JOIN pls_congenere d ON (b.nr_seq_congenere = d.nr_sequencia)
LEFT OUTER JOIN pls_intercambio e ON (b.nr_seq_intercambio = e.nr_sequencia);


BEGIN

open C01;
loop
fetch C01 into
	cd_estab_contrato_w,
	nr_seq_segurado_w,
	cd_estab_plano_w,
	ie_tipo_segurado_w,
	cd_estab_congenere_w,
	cd_estab_intercambio_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if (ie_tipo_segurado_w  ('A','B')) then
		update	pls_segurado
		set	cd_estabelecimento	=  coalesce(cd_estab_contrato_w,cd_estab_plano_w)
		where	nr_sequencia		= nr_seq_segurado_w;
	elsif (ie_tipo_segurado_w = 'P') then

		begin
		select	cd_estabelecimento
		into STRICT	cd_estab_pericia_w
		from	pls_pericia_medica
		where	nr_seq_segurado	= nr_seq_segurado_w;
		exception
		when others then
			cd_estab_pericia_w	:= cd_estab_plano_w;
		end;

		update	pls_segurado
		set	cd_estabelecimento	=  coalesce(cd_estab_pericia_w,cd_estab_plano_w)
		where	nr_sequencia		= nr_seq_segurado_w;

	elsif (ie_tipo_segurado_w = 'I') then
		update	pls_segurado
		set	cd_estabelecimento	= coalesce(cd_estab_congenere_w,cd_estab_plano_w)
		where	nr_sequencia		= nr_seq_segurado_w;
	elsif (ie_tipo_segurado_w = 'T') then
		update	pls_segurado
		set	cd_estabelecimento	= coalesce(cd_estab_intercambio_w,cd_estab_plano_w)
		where	nr_sequencia		= nr_seq_segurado_w;
	end if;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ajustar_segurado_estab () FROM PUBLIC;

