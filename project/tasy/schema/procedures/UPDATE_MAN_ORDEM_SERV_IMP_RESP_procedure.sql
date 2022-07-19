-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE update_man_ordem_serv_imp_resp (nr_sequencia_p man_ordem_serv_imp_resp.nr_sequencia%type, ds_justificativa_p man_ordem_serv_imp_resp.ds_justificativa%type, ie_aceite_p man_ordem_serv_imp_resp.ie_aceite%type, nm_usuario_p man_ordem_serv_imp_resp.nm_usuario%type) AS $body$
DECLARE


qt_reg_w				bigint;
nr_seq_ordem_serv_w		man_ordem_servico.nr_sequencia%type;
nr_seq_impacto_w		man_ordem_serv_imp_resp.nr_seq_impacto%type;
										

BEGIN

update	man_ordem_serv_imp_resp
set		ds_justificativa		= ds_justificativa_p,
		nm_usuario_aprovacao	= nm_usuario_p,
		ie_aceite				= ie_aceite_p,
		dt_aprovacao			= clock_timestamp()
where	nr_sequencia = nr_sequencia_p;

commit;

select	nr_seq_impacto
into STRICT	nr_seq_impacto_w
from	man_ordem_serv_imp_resp
where	nr_sequencia = nr_sequencia_p;

if (nr_seq_impacto_w IS NOT NULL AND nr_seq_impacto_w::text <> '') then
	select	nr_seq_ordem_serv
	into STRICT	nr_seq_ordem_serv_w
	from	man_ordem_serv_impacto
	where	nr_sequencia = nr_seq_impacto_w;

	if (nr_seq_ordem_serv_w IS NOT NULL AND nr_seq_ordem_serv_w::text <> '') then
		select	count(1)
		into STRICT	qt_reg_w
		from	man_ordem_serv_imp_resp
		where	nr_seq_impacto	= nr_seq_impacto_w
		and		coalesce(dt_aprovacao::text, '') = ''
		and		coalesce(ie_resposta, 'N') = 'S';
		
		if (qt_reg_w = 0) then	
			CALL man_liberar_analise_impacto(nr_seq_ordem_serv_w, nr_seq_impacto_w, nm_usuario_p);
		end if;

	end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE update_man_ordem_serv_imp_resp (nr_sequencia_p man_ordem_serv_imp_resp.nr_sequencia%type, ds_justificativa_p man_ordem_serv_imp_resp.ds_justificativa%type, ie_aceite_p man_ordem_serv_imp_resp.ie_aceite%type, nm_usuario_p man_ordem_serv_imp_resp.nm_usuario%type) FROM PUBLIC;

