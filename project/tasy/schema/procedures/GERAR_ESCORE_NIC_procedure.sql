-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_escore_nic ( nr_seq_nic_p bigint) AS $body$
DECLARE

ie_pa_max_w			escala_nic.ie_pa_max%type;
ie_balao_aortico_w		escala_nic.ie_balao_aortico%type;
ie_insuf_card_w			escala_nic.ie_insuf_card%type;
ie_idade_w			escala_nic.ie_idade%type;
ie_anemia_w			escala_nic.ie_anemia%type;
ie_diabete_w			escala_nic.ie_diabete%type;
qt_contraste_w			escala_nic.qt_contraste%type;
ie_creatinina_serica_maior_w	escala_nic.ie_creatinina_serica_maior%type;
ie_clearence_creatinina_w	escala_nic.ie_clearence_creatinina%type;
qt_creatinina_serica_w		escala_nic.qt_creatinina_serica%type;
qt_escore_w			escala_nic.qt_escore%type := 0;
qt_risco_nic_w			escala_nic.qt_risco_nic%type := 0;
qt_risco_dialise_w		escala_nic.qt_risco_dialise%type := 0;
ie_creatinia_w	escala_nic.ie_creatinia%type;
qt_clearence_creatinina_w	escala_nic.qt_clearence_creatinina%type;
			

BEGIN
if (coalesce(nr_seq_nic_p,0) > 0) then
	select	ie_pa_max,
		ie_balao_aortico,
		ie_insuf_card, 
		ie_idade, 
		ie_anemia, 
		ie_diabete, 
		qt_contraste, 
		ie_creatinina_serica_maior, 
		ie_clearence_creatinina, 
		qt_creatinina_serica,
		ie_creatinia,
		qt_clearence_creatinina
	into STRICT	ie_pa_max_w,
		ie_balao_aortico_w, 
		ie_insuf_card_w, 
		ie_idade_w, 
		ie_anemia_w, 
		ie_diabete_w, 
		qt_contraste_w, 
		ie_creatinina_serica_maior_w, 
		ie_clearence_creatinina_w, 
		qt_creatinina_serica_w,
		ie_creatinia_w,
		qt_clearence_creatinina_w
	from	escala_nic
	where	nr_sequencia = nr_seq_nic_p;
	
	if (ie_pa_max_w = 'S') then
		qt_escore_w := qt_escore_w + 5;
	end if;
	
	if (ie_balao_aortico_w = 'S') then
		qt_escore_w := qt_escore_w + 5;
	end if;
	
	if (ie_insuf_card_w = 'S') then
		qt_escore_w := qt_escore_w + 5;
	end if;
	
	if (ie_idade_w = 'S') then
		qt_escore_w := qt_escore_w + 4;
	end if;
	
	if (ie_anemia_w = 'S') then
		qt_escore_w := qt_escore_w + 3;
	end if;
	
	if (ie_diabete_w = 'S') then
		qt_escore_w := qt_escore_w + 3;
	end if;
	
	if (ie_creatinina_serica_maior_w = 'S') then
		qt_escore_w := qt_escore_w + 4;
	end if;
	
    if (ie_creatinia_w = 'CC') then
        if (qt_clearence_creatinina_w  >= 40 and qt_clearence_creatinina_w < 60) then
            qt_escore_w := qt_escore_w + 2;
        elsif (qt_clearence_creatinina_w >= 20 and qt_clearence_creatinina_w < 39) then
            qt_escore_w := qt_escore_w + 4;
        elsif (qt_clearence_creatinina_w < 20) then
            qt_escore_w := qt_escore_w + 6;
        end if;
    elsif (ie_creatinia_w = 'CS' and qt_creatinina_serica_w > 1.5) then
        qt_escore_w := qt_escore_w + 4;		
    end if;		
	
	qt_escore_w := qt_escore_w + round(qt_contraste_w/100);
	
	if (qt_escore_w <= 5) then
		qt_risco_nic_w		:= 7.5;
		qt_risco_dialise_w	:= 0.04;
	elsif (qt_escore_w <= 10) then
		qt_risco_nic_w		:= 14;
		qt_risco_dialise_w	:= 0.12;
	elsif (qt_escore_w < 16) then
		qt_risco_nic_w		:= 26.1;
		qt_risco_dialise_w	:= 1.09;
	elsif (qt_escore_w >= 16) then
		qt_risco_nic_w		:= 57.3;
		qt_risco_dialise_w	:= 12.6;
	end if;
	
	update	escala_nic
	set	qt_escore		= qt_escore_w,
		qt_risco_nic		= qt_risco_nic_w,
		qt_risco_dialise	= qt_risco_dialise_w
	where	nr_sequencia		= nr_seq_nic_p;
	
	end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_escore_nic ( nr_seq_nic_p bigint) FROM PUBLIC;
