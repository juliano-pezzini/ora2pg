-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_existe_comunic_cih ( nr_atendimento_p bigint, cd_medico_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1);
ds_result_w			varchar(1);
permissao_w			varchar(1);
ie_destinatario_w	varchar(5);
cd_prescr_w			varchar(10);
cd_medico_w			varchar(10);
qt_prescr_w			bigint;
nr_prescr_w			bigint;
nr_seq_comunic_w	bigint;
eh_medico_w			bigint;

C01 CURSOR FOR
SELECT	p.nr_prescricao,
		c.nr_sequencia
from	prescr_medica p,
		prescr_material m,
		prescr_mat_comunic_cih c
where	p.nr_prescricao 	= m.nr_prescricao
and		c.nr_prescricao 	= m.nr_prescricao
and		c.nr_seq_prescricao = m.nr_sequencia
and		p.nr_atendimento 	= nr_atendimento_p
and 	c.ie_ciente = 'N'
and 	coalesce(c.nr_seq_pres_mat_com,0) = 0
and 	not exists (	select	1
						from	prescr_mat_comunic_cih x
						where	x.nr_seq_pres_mat_com = c.nr_sequencia);


BEGIN

ds_result_w	:= 'N';

open C01;
loop
fetch C01 into
	nr_prescr_w,
	nr_seq_comunic_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	max(t.ie_destinatario)
	into STRICT	ie_destinatario_w
	from	tipo_comunicado_cih t,
			prescr_mat_comunic_cih c
	where	t.nr_sequencia 	= c.nr_seq_tipo
	and		c.nr_prescricao = nr_prescr_w
	and		c.nr_sequencia 	= nr_seq_comunic_w;

	if (ie_destinatario_w = 'MCC') then
		select	max(ie_corpo_clinico)
		into STRICT	permissao_w
		from	medico
		where	cd_pessoa_fisica = cd_medico_p;

	elsif (ie_destinatario_w = 'MP') then
		select	max(cd_prescritor)
		into STRICT	cd_prescr_w
		from	prescr_medica
		where	nr_prescricao = nr_prescr_w;

		if (cd_prescr_w = cd_medico_p) then
			permissao_w := 'S';
		else
			permissao_w := 'N';
		end if;
	elsif (ie_destinatario_w = 'QM') then
		select	count(*)
		into STRICT	eh_medico_w
		from	medico
		where	cd_pessoa_fisica = cd_medico_p;

		if (eh_medico_w = 0) then
			permissao_w := 'N';
		else
			permissao_w := 'S';
		end if;
	end if;

	if (ds_result_w <> 'S') then
		ds_result_w 	:= permissao_w;
	end if;

	select	cd_pessoa_destino
	into STRICT	cd_medico_w
	from	prescr_mat_comunic_cih
	where	nr_prescricao 	= nr_prescr_w
	and		nr_sequencia 	= nr_seq_comunic_w;

	if (cd_medico_w = cd_medico_p) then
		ds_result_w := 'S';
	end if;

	end;
end loop;
close C01;

ds_retorno_w := ds_result_w;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_existe_comunic_cih ( nr_atendimento_p bigint, cd_medico_p text) FROM PUBLIC;

