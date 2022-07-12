-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_val_transfusions ( NR_ORDER_UNIT_P text , cd_pessoa_fisica_p text ) RETURNS bigint AS $body$
DECLARE

qt_records_w		prescr_solic_bco_sangue.nr_seq_hemo_cpoe%type := null;
qt_records_prescr_w	bigint := null;
ie_status_w       san_transfusao.DS_OBSERVACAO%type := null;
ie_cancel_w 	  san_transfusao.IE_STATUS%type := null;
ie_cirugia_w  	  san_reserva.NR_PRESCRICAO%type := null;
nr_seq_cpoe_w		prescr_solic_bco_sangue.nr_seq_hemo_cpoe%type := null;
is_acknowledged_w	cpoe_tipo_pedido.ie_situacao%type := null;
nr_prescricao_w prescr_medica.nr_prescricao%type := null;
result_w		bigint := null;


BEGIN

select max(a.nr_prescricao)
into STRICT nr_prescricao_w
from prescr_solic_bco_sangue a,
cpoe_hemoterapia b,
cpoe_order_unit c
where a.nr_seq_hemo_cpoe = b.nr_sequencia
and b.nr_seq_cpoe_order_unit = c.nr_sequencia
and c.nr_order_unit = nr_order_unit_p;

select	count(*)	count_san_reserva
into STRICT  qt_records_w
from	san_reserva
where	nr_prescricao = nr_prescricao_w;

if (qt_records_w > 0) then

    select	count(*)	count_san_transfusao,
	 RTRIM(XMLAGG(XMLELEMENT[e,IE_STATUS,','].EXTRACT('//text()') ORDER BY IE_STATUS).GetClobVal(),',') AS  ie_status_grp
    into STRICT  qt_records_prescr_w ,ie_status_w
    from	san_transfusao
    where	nr_prescricao = nr_prescricao_w
    and		cd_pessoa_fisica = cd_pessoa_fisica_p;

    if (qt_records_prescr_w > 0) then
	
        select max(nr_seq_hemo_cpoe) 
        into STRICT  nr_seq_cpoe_w 
        from   prescr_solic_bco_sangue
        where nr_prescricao = nr_prescricao_w;

        select adep_obtain_acknowledged('HM', nr_seq_cpoe_w)
        into STRICT is_acknowledged_w 
;
        
        if (is_acknowledged_w = 'N') then 
        
            result_w := 4;

        else 
    
            result_w := 1;

        end if;
		
		select CASE WHEN COUNT(*)=0 THEN 'Y'  ELSE 'N' END  into STRICT ie_cancel_w from
		table(lista_pck.obter_lista_char(ie_status_w,',')) 
		where CD_REGISTRO <>'C';

		if (ie_cancel_w='Y') then
			result_w := 5;
		end if;
		
		SELECT PKG_DATE_UTILS.get_DiffDate(clock_timestamp(),max(DT_CIRURGIA) ,'DAY')
		into STRICT ie_cirugia_w
		from	san_reserva
		where	nr_prescricao = nr_prescricao_w
		and		cd_pessoa_fisica = cd_pessoa_fisica_p;
		
		if (ie_cirugia_w>0 ) then
			result_w := 6;
		end if;
		

    else 
        
        result_w := 3;
        return result_w;

    end if;

else

    result_w := 2;

end if;

return result_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_val_transfusions ( NR_ORDER_UNIT_P text , cd_pessoa_fisica_p text ) FROM PUBLIC;

