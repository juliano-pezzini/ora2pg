-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_status_solic_bionexo ( nr_solic_compra_p bigint, ie_status_bionexo_p text, ds_mensagem_p text, nm_usuario_p text) AS $body$
DECLARE

 
ds_mensagem_w		varchar(255);						
						 

BEGIN 
if (nr_solic_compra_p IS NOT NULL AND nr_solic_compra_p::text <> '') then 
 
	update solic_compra 
	set  ie_status_bionexo = ie_status_bionexo_p 
	where nr_solic_compra = nr_solic_compra_p;
  
	 
	if (ie_status_bionexo_p = 'AE') then 
		--ds_mensagem_w := 'Solicitação aprovada, aguardado envio para a Bionexo.'; 
		ds_mensagem_w := Wheb_mensagem_pck.get_Texto(297659);
	elsif (ie_status_bionexo_p = 'AR') then 
		--ds_mensagem_w := 'Envio realizado com sucesso. Está aguardando retorno dos preços por parte da Bionexo.'; 
		ds_mensagem_w := Wheb_mensagem_pck.get_Texto(297660);
	elsif (ie_status_bionexo_p = 'EE') then 
		--ds_mensagem_w := substr('Erro ao enviar a solicitação para Bionexo. ' || DS_MENSAGEM_P,1,255); 
		ds_mensagem_w := substr(Wheb_mensagem_pck.get_Texto(297661, 'DS_MENSAGEM_P='||DS_MENSAGEM_P),1,255);
	elsif (ie_status_bionexo_p = 'RP') then 
		--ds_mensagem_w := 'Recebimento parcial dos itens da solicitação por parte da Bionexo. Ainda falta gerar OC de alguns itens.'; 
		ds_mensagem_w := Wheb_mensagem_pck.get_Texto(297662);
	elsif (ie_status_bionexo_p = 'RC') then 
		--ds_mensagem_w := 'Todos os itens da solicitação já foram recebidos da Bionexo.'; 
		ds_mensagem_w := Wheb_mensagem_pck.get_Texto(297663);
	elsif (ie_status_bionexo_p = 'RE') then 
		--ds_mensagem_w := 'Reenviado a integração para a Bionexo.'; 
		ds_mensagem_w := Wheb_mensagem_pck.get_Texto(297664);
	end if;
	 
	 
	CALL gravar_log_bionexo(nr_solic_compra_p, ie_status_bionexo_p, ds_mensagem_w, nm_usuario_p);
  
end if;
 
if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_status_solic_bionexo ( nr_solic_compra_p bigint, ie_status_bionexo_p text, ds_mensagem_p text, nm_usuario_p text) FROM PUBLIC;

