-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sup_verifica_email_pend ( cd_estabelecimento_p bigint) AS $body$
DECLARE

 
ie_tipo_mensagem_w	varchar(15);
qt_pendente_w		bigint;
ie_email_dia_util_w	varchar(2);
qt_registros_w		bigint;

c01 CURSOR FOR 
SELECT	ie_tipo_mensagem 
from	regra_envio_compra_agrup 
where	cd_estabelecimento = cd_estabelecimento_p 
and	to_char(clock_timestamp(),'hh24') = trim(both to_char(hr_enviar,'00')) 
group by	ie_tipo_mensagem;


BEGIN 
 
open c01;
loop 
fetch c01 into 
	ie_tipo_mensagem_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
 
	ie_email_dia_util_w := 'N';
 
	select	count(*) 
	into STRICT	qt_registros_w 
	from	regra_envio_email_compra 
	where	cd_estabelecimento = cd_estabelecimento_p 
	and	ie_tipo_mensagem = ie_tipo_mensagem_w 
	and	ie_email_dia_util = 'S' 
	and	ie_situacao = 'A';
 
	if (qt_registros_w > 0) then 
		ie_email_dia_util_w := 'S';
	end if;	
	 
	select	count(*) 
	into STRICT	qt_pendente_w 
	from	envio_email_compra_agrup a 
	where	cd_estabelecimento = cd_estabelecimento_p 
	and	ie_tipo_mensagem = ie_tipo_mensagem_w 
	and	coalesce(a.ie_cancelado,'N') = 'N' 
	and	exists (SELECT	1 
			from	email_compra_agrup_dest x 
			where	x.nr_seq_envio = a.nr_sequencia 
			and	coalesce(x.ie_enviado,'N') = 'N');
 
	if (qt_pendente_w > 0) then 
		begin 
		if (ie_email_dia_util_w = 'S') then 
			begin 
			if (obter_se_dia_util(clock_timestamp(), cd_estabelecimento_p) = 'S') then 
				CALL envia_email_compra_agrup_hora(ie_tipo_mensagem_w, cd_estabelecimento_p);
			end if;	
			end;
		else	 
			begin 
			CALL envia_email_compra_agrup_hora(ie_tipo_mensagem_w, cd_estabelecimento_p);
			end;
		end if;
		end;
	end if;
 
	end;
end loop;
close c01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_verifica_email_pend ( cd_estabelecimento_p bigint) FROM PUBLIC;
