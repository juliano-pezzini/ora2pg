-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fa_obter_tipo_entrega_princ (nr_seq_entrega_p bigint) RETURNS varchar AS $body$
DECLARE


ie_tipo_entrega_w	varchar(3);
ie_paciente_pmc_w	varchar(1);
ie_medicamento_pmc_w	varchar(3);
ie_nutricao_w		varchar(3);
C01 CURSOR FOR
	SELECT	coalesce(d.ie_nutricao,'N'),
		coalesce(d.ie_medicamento_pmc,'N')
	from 	fa_paciente_entrega b,
		FA_ENTREGA_MEDICACAO a,
		fa_paciente_pmc_medic c,
		fa_medic_farmacia_amb d,
		fa_paciente_pmc e,
		fa_entrega_medicacao_item f
	where 	b.nr_sequencia = a.NR_SEQ_PACIENTE_ENTREGA
	AND	b.nr_sequencia = nr_seq_entrega_p
	and	e.nr_sequencia = b.nr_seq_paciente_pmc
	and	e.nr_sequencia = c.nr_seq_fa_pmc
	and	d.nr_sequencia = c.nr_seq_medic_fa
	and	f.nr_seq_fa_entrega = a.nr_sequencia
	and	f.cd_material = d.cd_material
	and	((coalesce(d.ie_nutricao,'N') = 'S') or (coalesce(d.ie_medicamento_pmc,'N') = 'S'));


BEGIN

ie_tipo_entrega_w	:= 'N';

if (nr_seq_entrega_p IS NOT NULL AND nr_seq_entrega_p::text <> '') then


	open C01;
	loop
	fetch C01 into
		ie_nutricao_w,
		ie_medicamento_pmc_w;
	EXIT WHEN NOT FOUND or ie_nutricao_w = 'S';  /* apply on C01 */
		begin
		null;
		end;
	end loop;
	close C01;


	if (ie_nutricao_w = 'S') then
		ie_tipo_entrega_w := 'PNC';
	elsif (ie_medicamento_pmc_w = 'S') then
		ie_tipo_entrega_w := 'PMC';
	else
		ie_tipo_entrega_w := 'N';
	end if;

	if (ie_tipo_entrega_w = 'N') then
		select	fa_obter_tipo_entrega_pac(nr_seq_paciente_pmc)
		into STRICT	ie_tipo_entrega_w
		from	fa_paciente_entrega
		where	nr_sequencia = nr_seq_entrega_p;
	end if;

end if;

return	ie_tipo_entrega_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fa_obter_tipo_entrega_princ (nr_seq_entrega_p bigint) FROM PUBLIC;
