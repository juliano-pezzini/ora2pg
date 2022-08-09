-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE order_reprocess_hl7_tie () AS $body$
DECLARE


c01 CURSOR FOR
  SELECT  a.nr_sequencia,
          a.ds_hl7
	from	  hl7_order_communication a
	where	  a.ie_status = 'E'
	order by nr_sequencia desc;
	
nr_sequencia_w	hl7_order_communication.nr_sequencia%type;
ds_hl7_w		    hl7_order_communication.ds_hl7%type;
json_w        	philips_json;
json_data_w   	text;


BEGIN

	open c01;
  loop
  fetch c01 into
	  nr_sequencia_w,
		ds_hl7_w;		
  EXIT WHEN NOT FOUND; /* apply on c01 */
	  begin
		
	    update  hl7_order_communication
		  set		  ie_status = 'P'			
		  where	  nr_sequencia = nr_sequencia_w;
			
		  json_data_w := bifrost.send_integration_content('inbound.order.ORM_001', ds_hl7_w, wheb_usuario_pck.get_nm_usuario);

	  end;
  end loop;

  commit;

end order_reprocess_hl7_tie;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE order_reprocess_hl7_tie () FROM PUBLIC;
