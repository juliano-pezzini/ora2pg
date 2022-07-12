-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_lista_kit_vinc_agenda (nr_seq_agenda_p bigint) RETURNS varchar AS $body$
DECLARE



ie_ordem_w		smallint;
cd_kit_material_w	bigint;
ds_kit_material_w	varchar(100);
ds_lista_kit_w		varchar(4000) := null;
nr_seq_proc_interno_w	proc_interno.nr_sequencia%type;
cd_medico_kit_w 			pessoa_fisica.cd_pessoa_fisica%type;
cd_medico_agenda_w		pessoa_fisica.cd_pessoa_fisica%type;

c01 CURSOR FOR
	SELECT   1 ie_ordem,
				b.cd_kit_material,
				substr(k.ds_kit_material,1,100) ds_kit_material,
				null cd_medico_kit,
				null cd_medico_agenda
	from     kit_material k,
				proc_interno b,
				agenda_paciente a
	where    a.nr_seq_proc_interno= b.nr_sequencia
	and      a.nr_sequencia       = nr_seq_agenda_p
	and      b.cd_kit_material    = k.cd_kit_material
	and      k.ie_situacao        = 'A'
	and		(a.nr_seq_proc_interno IS NOT NULL AND a.nr_seq_proc_interno::text <> '')
	and		(b.cd_kit_material IS NOT NULL AND b.cd_kit_material::text <> '')
	
union

	SELECT   1 ie_ordem,
				c.cd_kit_material,
				substr(k.ds_kit_material,1,100) ds_kit_material,
				c.cd_medico cd_medico_kit,
				a.cd_medico cd_medico_agenda
	from     kit_material k,
				proc_interno b,
				proc_interno_kit c,
				agenda_paciente a
	where    a.nr_seq_proc_interno= b.nr_sequencia
	and      c.nr_seq_proc_interno= b.nr_sequencia
	and      a.nr_sequencia       = nr_seq_agenda_p
	--and      ((c.cd_medico         = a.cd_medico) or (c.cd_medico is null) or (a.cd_medico is null))
	and      c.cd_kit_material    = k.cd_kit_material
	and      k.ie_situacao        = 'A'
	and		(a.nr_seq_proc_interno IS NOT NULL AND a.nr_seq_proc_interno::text <> '');

c02 CURSOR FOR
	SELECT   2 ie_ordem,
				b.cd_kit_material,
				substr(k.ds_kit_material,1,100) ds_kit_material,
				null cd_medico_kit,
				null cd_medico_agenda
	from     kit_material k,
				proc_interno b,
				agenda_paciente_proc a
	where    a.nr_seq_proc_interno= b.nr_sequencia
	and      a.nr_sequencia       = nr_seq_agenda_p
	and      b.cd_kit_material    = k.cd_kit_material
	and      k.ie_situacao        = 'A'
	and		(a.nr_seq_proc_interno IS NOT NULL AND a.nr_seq_proc_interno::text <> '')
	and		(b.cd_kit_material IS NOT NULL AND b.cd_kit_material::text <> '')
	
union

	SELECT   2 ie_ordem,
				c.cd_kit_material,
				substr(k.ds_kit_material,1,100) ds_kit_material,
				c.cd_medico cd_medico_kit,
				a.cd_medico cd_medico_agenda
	from     kit_material k,
				proc_interno b,
				proc_interno_kit c,
				agenda_paciente_proc a
	where    a.nr_seq_proc_interno= b.nr_sequencia
	and      c.nr_seq_proc_interno= b.nr_sequencia
	--and      ((c.cd_medico         = a.cd_medico) or (c.cd_medico is null) or (a.cd_medico is null))
	and      a.nr_sequencia       = nr_seq_agenda_p
	and      c.cd_kit_material    = k.cd_kit_material
	and      k.ie_situacao        = 'A'
	and		(a.nr_seq_proc_interno IS NOT NULL AND a.nr_seq_proc_interno::text <> '');


BEGIN

if (coalesce(nr_seq_agenda_p,0) > 0) then
	select	max(nr_seq_proc_interno)
	into STRICT		nr_seq_proc_interno_w
	from		agenda_paciente
	where		nr_sequencia       = nr_seq_agenda_p;

	if (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '') then
		open c01;
		loop
		fetch c01 into
			ie_ordem_w,
			cd_kit_material_w,
			ds_kit_material_w,
			cd_medico_kit_w,
			cd_medico_agenda_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin
			if (cd_medico_kit_w = cd_medico_agenda_w) or (coalesce(cd_medico_kit_w::text, '') = '') or (coalesce(cd_medico_agenda_w::text, '') = '') then
				if (coalesce(ds_lista_kit_w::text, '') = '') then
					ds_lista_kit_w :=  substr('[' ||cd_kit_material_w || ' - ' ||ds_kit_material_w||']',1,4000);
				else
					ds_lista_kit_w :=  substr(ds_lista_kit_w || '[' ||cd_kit_material_w || ' - ' ||ds_kit_material_w||']',1,4000);
				end if;
			end if;
			end;
		end loop;
		close c01;
	end if;

	select	max(nr_seq_proc_interno)
	into STRICT		nr_seq_proc_interno_w
	from		agenda_paciente_proc
	where		nr_sequencia       = nr_seq_agenda_p;

	if (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '') then
		open c02;
		loop
		fetch c02 into
			ie_ordem_w,
			cd_kit_material_w,
			ds_kit_material_w,
			cd_medico_kit_w,
			cd_medico_agenda_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			if (cd_medico_kit_w = cd_medico_agenda_w) or (coalesce(cd_medico_kit_w::text, '') = '') or (coalesce(cd_medico_agenda_w::text, '') = '') then
				if (coalesce(ds_lista_kit_w::text, '') = '') then
					ds_lista_kit_w :=  substr('[' ||cd_kit_material_w || ' - ' ||ds_kit_material_w||']',1,4000);
				else
					ds_lista_kit_w :=  substr(ds_lista_kit_w || '[' ||cd_kit_material_w || ' - ' ||ds_kit_material_w||']',1,4000);
				end if;
			end if;
			end;
		end loop;
		close c02;
	end if;
end if;

return ds_lista_kit_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_lista_kit_vinc_agenda (nr_seq_agenda_p bigint) FROM PUBLIC;

