-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE conciliar_integr_resp_rec_pck2.conciliar_lotes () AS $body$
DECLARE


qt_protocolo		integer := 0;
ie_status_w		    imp_resp_recurso_prot.ie_status%type;
nr_seq_protocolo_w	protocolo_convenio.nr_seq_protocolo%type;

clotes CURSOR FOR
	SELECT	nr_lote_prestador,
            coalesce(nr_seq_protocolo,0) nr_protoc_tasy,
            nr_protocolo_operadora,
            nr_sequencia,
            cd_convenio,
            cd_estabelecimento
	from	imp_resp_recurso_prot a
	where	coalesce(a.ie_status,'P') = 'P'
	order by a.nr_sequencia;

clotes_w clotes%rowtype;	


BEGIN
PERFORM set_config('conciliar_integr_resp_rec_pck2.i', 0, false);
open clotes;
loop
fetch clotes into	
	clotes_w;
EXIT WHEN NOT FOUND; /* apply on clotes */
	nr_Seq_protocolo_w := 0;
	if (clotes_w.nr_protoc_tasy > 0) then

		select	count(1)
		into STRICT	qt_protocolo
		from	protocolo_convenio x
		where	x.nr_seq_protocolo 	= clotes_w.nr_protoc_tasy
		and	    x.cd_convenio	  	= clotes_w.cd_convenio
		and	    x.cd_estabelecimento 	= clotes_w.cd_estabelecimento;

		if (qt_protocolo = 0) then
			ie_status_w := 'PN';--Lote não encontrado no "Protocolo convênio"			
		else
			ie_status_w := 'C';--Conciliado
            nr_Seq_protocolo_w := clotes_w.nr_protoc_tasy;
		end if;
	else	
		nr_Seq_protocolo_w := coalesce(Tiss_Obter_Seq_Protocolo_Xml(clotes_w.cd_convenio,clotes_w.nr_lote_prestador),0);
		if (nr_Seq_protocolo_w > 0) then

			ie_status_w := 'C';
		else	
			ie_status_w := 'PN';

		end if;

	end if;

    RAISE NOTICE 'atualizando o protocolo: %', nr_Seq_protocolo_w;
	current_setting('conciliar_integr_resp_rec_pck2.campos_lote_w')::campos_lote_v(current_setting('conciliar_integr_resp_rec_pck2.i')::integer).nr_seq_protocolo		:= nr_Seq_protocolo_w;
	current_setting('conciliar_integr_resp_rec_pck2.campos_lote_w')::campos_lote_v(current_setting('conciliar_integr_resp_rec_pck2.i')::integer).nr_sequencia			:= clotes_w.nr_sequencia;
	current_setting('conciliar_integr_resp_rec_pck2.campos_lote_w')::campos_lote_v(current_setting('conciliar_integr_resp_rec_pck2.i')::integer).ie_status			    := ie_status_w;
	-- Não precisa campos_lote_w(i).cd_convenio			:= clotes_w.cd_convenio;
	-- Não precisa campos_lote_w(i).cd_estabelecimento		:= clotes_w.cd_estabelecimento;
	PERFORM set_config('conciliar_integr_resp_rec_pck2.i', current_setting('conciliar_integr_resp_rec_pck2.i')::integer + 1, false);
end loop;
close clotes;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE conciliar_integr_resp_rec_pck2.conciliar_lotes () FROM PUBLIC;