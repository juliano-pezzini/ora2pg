-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE wheb_assist_pck.carregarpermissaoescala () AS $body$
DECLARE

	
	ie_escala_w	bigint;
	ie_restricao_uso_w	varchar(255);
	k  integer;
	cd_cgc_cliente_w	varchar(255)	:= wheb_assist_pck.getcgcestabelecimento();
	
	
	C010 CURSOR FOR
		SELECT	IE_RESTRICAO_USO,
				ie_escala
		from	ESCALA_DOCUMENTACAO;
			
	
	
BEGIN
	
	open C010;
	loop
	fetch C010 into	
		ie_restricao_uso_w,
		ie_escala_w;
	EXIT WHEN NOT FOUND; /* apply on C010 */
		begin
		k := current_setting('wheb_assist_pck.regraescala_w')::regraEscalaVetor.count+1;
		
		current_setting('wheb_assist_pck.regraescala_w')::regraEscalaVetor[k].ie_escala_w		:= ie_escala_w;
		current_setting('wheb_assist_pck.regraescala_w')::regraEscalaVetor[k].ie_restricao_uso_w	:= ie_restricao_uso_w;
		current_setting('wheb_assist_pck.regraescala_w')::regraEscalaVetor[k].ie_permite_w		:= 'S';
		
		if (cd_cgc_cliente_w	<> '01950338000177') then
			if (ie_restricao_uso_w	= 'N') then
				current_setting('wheb_assist_pck.regraescala_w')::regraEscalaVetor[k].ie_permite_w	:= 'N';
			elsif (ie_restricao_uso_w	= 'A') then
				current_setting('wheb_assist_pck.regraescala_w')::regraEscalaVetor[k].ie_permite_w	:= wheb_assist_pck.getliberacaoescalaestab(ie_escala_w);
			end if;	
		end if;
		end;
	end loop;
	close C010;
	

	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE wheb_assist_pck.carregarpermissaoescala () FROM PUBLIC;
