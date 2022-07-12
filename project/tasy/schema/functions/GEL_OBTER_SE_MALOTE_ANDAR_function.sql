-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gel_obter_se_malote_andar (nr_malote_p bigint, cd_setor_p bigint) RETURNS varchar AS $body$
DECLARE

 
qt_itens_w	bigint;
qt_andar_w	bigint;
ie_retorno_w	varchar(1);
			

BEGIN 
 
if (nr_malote_p IS NOT NULL AND nr_malote_p::text <> '') and (cd_setor_p IS NOT NULL AND cd_setor_p::text <> '') then 
 
	select	count(*) 
	into STRICT	qt_itens_w 
	from	malote_envelope_item 
	where	nr_seq_malote = nr_malote_p;
	 
	select count(*) 
	into STRICT	qt_andar_w 
	from	malote_envelope_item a, 
		envelope_laudo_item b, 
		prescr_procedimento c, 
		prescr_medica d 
	where	b.nr_seq_envelope = a.nr_seq_envelope 
	and	b.nr_prescricao = c.nr_prescricao 
	and	b.nr_seq_prescr = c.nr_sequencia 
	and	c.nr_prescricao = d.nr_prescricao 
	and	a.nr_seq_malote = nr_malote_p 
	and	obter_setor_atendimento(d.nr_atendimento) = cd_setor_p;
	 
	if (qt_itens_w = qt_andar_w) then 
		ie_retorno_w	:= 'S';
	else 
		ie_retorno_w	:= 'N';
	end if;
 
end if;
 
return	ie_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gel_obter_se_malote_andar (nr_malote_p bigint, cd_setor_p bigint) FROM PUBLIC;

