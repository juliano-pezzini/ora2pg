-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qua_gravar_expiracao_documento ( nm_usuario_p text) AS $body$
DECLARE

 
C01 CURSOR FOR 
	SELECT	nr_sequencia, 
		cd_estabelecimento 
	from	qua_documento a 
	where	(a.dt_elaboracao IS NOT NULL AND a.dt_elaboracao::text <> '') 
	and	coalesce(a.dt_validacao::text, '') = '' 
	and	coalesce(a.dt_aprovacao::text, '') = '' 
	and	coalesce(a.ie_status,'A') = 'E' 
	and	a.dt_elaboracao + coalesce(a.qt_dias_validacao,0) < clock_timestamp();	
 
C02 CURSOR FOR 
	SELECT	nr_sequencia, 
		cd_estabelecimento 
	from	qua_documento a 
	where	(a.dt_elaboracao IS NOT NULL AND a.dt_elaboracao::text <> '') 
	and	(a.dt_validacao IS NOT NULL AND a.dt_validacao::text <> '') 
	and	coalesce(a.dt_aprovacao::text, '') = '' 
	and	coalesce(a.ie_status,'A') = 'V' 
	and	a.dt_validacao + coalesce(a.qt_dias_aprovacao,0) < clock_timestamp();

c01_w			c01%rowtype;
c02_w			c02%rowtype;
	

BEGIN 
CALL wheb_usuario_pck.SET_IE_EXECUTAR_TRIGGER('N');
 
open C01;
loop 
fetch C01 into	 
	c01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
 
	update	qua_documento 
	set	ie_status = 'X', 
		nm_usuario = nm_usuario_p, 
		dt_atualizacao = clock_timestamp() 
	where	nr_sequencia = c01_w.nr_sequencia;
	 
	CALL qua_gerar_envio_comunicacao(c01_w.nr_sequencia,'0',nm_usuario_p,'32',c01_w.cd_estabelecimento,0,0,'N');
	 
	update	qua_documento 
	set	ie_status = 'E', 
		nm_usuario = nm_usuario_p, 
		dt_atualizacao = clock_timestamp(), 
		dt_elaboracao = clock_timestamp() 
	where	nr_sequencia = c01_w.nr_sequencia;
	 
	CALL qua_gerar_envio_comunicacao(c01_w.nr_sequencia,'0',nm_usuario_p,'8',c01_w.cd_estabelecimento,0,0,'N');
	 
	end;
end loop;
close C01;
 
open C02;
loop 
fetch C02 into 
	c02_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin 
	 
	update	qua_documento 
	set	ie_status = 'X', 
		nm_usuario = nm_usuario_p, 
		dt_atualizacao = clock_timestamp() 
	where	nr_sequencia = c02_w.nr_sequencia;
	 
	CALL qua_gerar_envio_comunicacao(c02_w.nr_sequencia,'0',nm_usuario_p,'32',c02_w.cd_estabelecimento,0,0,'N');
	 
	update	qua_documento 
	set	ie_status = 'V', 
		nm_usuario = nm_usuario_p, 
		dt_atualizacao = clock_timestamp(), 
		dt_validacao = clock_timestamp() 
	where	nr_sequencia = c02_w.nr_sequencia;
	 
	CALL qua_gerar_envio_comunicacao(c02_w.nr_sequencia,'0',nm_usuario_p,'9',c02_w.cd_estabelecimento,0,0,'N');
	 
	end;
end loop;
close C02;
 
commit;
CALL wheb_usuario_pck.SET_IE_EXECUTAR_TRIGGER('S');
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qua_gravar_expiracao_documento ( nm_usuario_p text) FROM PUBLIC;

