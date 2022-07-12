-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fleury_obter_se_prescricao_int (nr_prescricao_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w			varchar(1);
qt_registros_w			bigint;

ie_agrupa_ficha_fleury_w	lab_parametro.ie_agrupa_ficha_fleury%type;
nr_controle_w			prescr_medica.nr_controle%type;
			

BEGIN 
ds_retorno_w	:= 'N';
 
if (obter_se_existe_evento(106) = 'S') then 
 
	select	coalesce(max(ie_agrupa_ficha_fleury),'N') ds 
	into STRICT	ie_agrupa_ficha_fleury_w 
	from	lab_parametro a 
	where	a.cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;
 
	select	max(a.nr_controle) 
	into STRICT	nr_controle_w 
	from	prescr_medica a 
	where	a.nr_prescricao = nr_prescricao_p;
 
	if (coalesce(nr_controle_w::text, '') = '') or (ie_agrupa_ficha_fleury_w <> 'N') then 
 
		select	count(*) 
		into STRICT	qt_registros_w 
		from	prescr_procedimento a 
		where	(a.nr_seq_exame IS NOT NULL AND a.nr_seq_exame::text <> '') 
		and	a.nr_prescricao = nr_prescricao_p;
 
		if (qt_registros_w <> 0) and (obter_se_int_prescr_fleury(nr_prescricao_p) <> '0') then 
			ds_retorno_w	:= 'S';
		else 
			select	count(*) 
			into STRICT	qt_registros_w 
			from	prescr_procedimento a 
			where	coalesce(a.nr_seq_exame::text, '') = '' 
			and	a.nr_prescricao = nr_prescricao_p;
			 
			if (qt_registros_w <> 0) and (obter_se_int_pr_fleury_diag(nr_prescricao_p) <> '0') then 
				ds_retorno_w	:= 'S';
			end if;
		end if;
	end if;
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fleury_obter_se_prescricao_int (nr_prescricao_p bigint) FROM PUBLIC;

