-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_recomendacao ( nr_prescricao_p bigint, nr_sequencia_p bigint, nr_seq_horario_p bigint) RETURNS varchar AS $body$
DECLARE


ie_status_w			varchar(1) := 'N';
ie_status_horario_w			varchar(1) := 'N';
cd_recomendacao_w	bigint;
				

BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and ((coalesce(nr_sequencia_p,nr_seq_horario_p) IS NOT NULL AND (coalesce(nr_sequencia_p,nr_seq_horario_p))::text <> '')) then

	if ((coalesce(nr_seq_horario_p,cd_recomendacao_w) IS NOT NULL AND (coalesce(nr_seq_horario_p,cd_recomendacao_w))::text <> '')) then
		select	CASE WHEN coalesce(max(a.ie_alteracao),0)=19 THEN 'I'  ELSE 'N' END
		into STRICT	ie_status_horario_w
		from	prescr_mat_alteracao a
		where	a.nr_prescricao = nr_prescricao_p
		and	a.nr_seq_horario_rec = nr_seq_horario_p
		and	coalesce(a.ie_evento_valido,'S') = 'S'
		and	ie_tipo_item = 'R'
		and	a.ie_alteracao <> 49
		and	((a.ie_alteracao <> 20) or 
			 not exists ( 	SELECT		1
					 from		prescr_mat_alteracao b
					 where		a.nr_prescricao = b.nr_prescricao
					 and		a.nr_seq_horario_rec = b.nr_seq_horario_rec
					 and		a.cd_item = b.cd_item
					 and		b.ie_alteracao in (4)
					 and		b.nr_sequencia > a.nr_sequencia));
	end if;
	
	if (ie_status_w = 'N') then
		ie_status_w := ie_status_horario_w;
	end if;
	
end if;

if (ie_status_w = 'N') then
	ie_status_w	:= null;
end if;

return	ie_status_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_recomendacao ( nr_prescricao_p bigint, nr_sequencia_p bigint, nr_seq_horario_p bigint) FROM PUBLIC;

