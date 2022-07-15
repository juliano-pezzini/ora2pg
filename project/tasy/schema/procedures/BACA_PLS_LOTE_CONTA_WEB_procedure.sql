-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_pls_lote_conta_web () AS $body$
DECLARE



nr_seq_prestador_web_w		bigint;
nr_seq_lote_procolo_w		bigint;
nr_seq_lote_procolo_conta_w	bigint;
qt_usuario_w			smallint	:= 0;
qt_protocolos_w			integer	:= 0;
nm_usuario_lote_w		varchar(255)	:= '';

C01 CURSOR FOR
	SELECT 	nr_seq_usu_prestador,
		nr_seq_lote_conta
	from	pls_protocolo_conta
	where	ie_forma_imp = 'P'
	and	ie_tipo_protocolo  = 'C'
	and	ie_origem_protocolo = 'E'
	and	ie_situacao in ('I', 'A','RE')
	and	(nr_seq_usu_prestador IS NOT NULL AND nr_seq_usu_prestador::text <> '')
	and	to_date(to_char(dt_atualizacao,'dd/mm/yyyy'),'dd/mm/yyyy') > to_date('01/01/2011','dd/mm/yyyy');

C02 CURSOR FOR
	SELECT 	nr_sequencia,
		nm_usuario_nrec
	from	pls_lote_protocolo_conta
	where 	coalesce(dt_geracao_analise::text, '') = ''
	and	nm_usuario_nrec <> 'WebService';


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_prestador_web_w,
	nr_seq_lote_procolo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
		select	count(1)
		into STRICT	qt_usuario_w
		from	pls_usuario_web
		where	nr_sequencia = nr_seq_prestador_web_w;

		if (qt_usuario_w > 0) then
			update	pls_lote_protocolo_conta
			set	nr_seq_prestador_web = nr_seq_prestador_web_w
			where	nr_sequencia = nr_seq_lote_procolo_w;
		end if;
	end;
end loop;
close C01;

open C02;
loop
fetch C02 into
	nr_seq_lote_procolo_conta_w,
	nm_usuario_lote_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
		select	count(1)
		into STRICT	qt_protocolos_w
		from	pls_protocolo_conta
		where	nr_seq_lote_conta = nr_seq_lote_procolo_conta_w;

		if (qt_protocolos_w = 0) then
			select 	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_prestador_web_w
			from	pls_usuario_web
			where	nm_usuario_web = nm_usuario_lote_w;

			if (nr_seq_prestador_web_w > 0) then
				update	pls_lote_protocolo_conta
				set	nr_seq_prestador_web = nr_seq_prestador_web_w
				where	nr_sequencia = nr_seq_lote_procolo_conta_w;
			end if;
		end if;
	end;
end loop;
close C02;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_pls_lote_conta_web () FROM PUBLIC;

