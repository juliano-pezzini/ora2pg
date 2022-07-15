-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_interface_assim ( cd_processo_autoriz_p text, nr_seq_protocolo_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE
 				
 
 
nr_interno_conta_w	bigint;
cd_item_w		integer;
ds_item_w		varchar(40);
vl_item_w		varchar(15);
ds_lista_item_w		varchar(2000);
contador_w		integer;
ie_troca_w		varchar(1);
cd_guia_w		varchar(20);
ds_indicacao_clinica_w varchar(100);
ds_erro_w		varchar(2000);
cd_processo_autoriz_w  varchar(10);

 
C01 CURSOR FOR 
	SELECT	nr_interno_conta 
	from	conta_paciente 
	where	nr_seq_protocolo = nr_seq_protocolo_p 
	order by nr_interno_conta;

C02 CURSOR FOR 
	SELECT	a.cd_item, 
		CASE WHEN a.ie_origem_proced=0 THEN substr(obter_desc_material(a.cd_item),1,40)  ELSE substr(obter_descricao_procedimento(a.cd_item,a.ie_origem_proced),1,40) END , 
		to_char(a.vl_total_item) 
	from	w_interf_conta_item a 
	where	a.nr_seq_protocolo = nr_seq_protocolo_p 
	and	a.nr_interno_conta = nr_interno_conta_w  
	and 	a.vl_total_item <= 9999 
	order by a.nr_interno_conta LIMIT 20;

BEGIN 
 
ds_lista_item_w:= '';
contador_w:=	0;
ds_indicacao_clinica_w:= '';
cd_guia_w:='';
ds_erro_w:= '';
 
delete	from	w_conta_assim 
where	nr_seq_protocolo = nr_seq_protocolo_p;
 
 
/* Pega todas as contas do protocolo */
 
 
OPEN C01;
LOOP 
FETCH C01 into 
	nr_interno_conta_w;	
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	ds_lista_item_w:= '';
	contador_w:=	0;
	 
	select	max(coalesce(b.nr_doc_convenio,0)) 
	into STRICT	cd_guia_w	 
	from	w_interf_conta_cab b 
	where	b.nr_interno_conta = nr_interno_conta_w 
	and 	b.nr_seq_protocolo = nr_seq_protocolo_p;
	 
	select	substr(obter_desc_cid(max(coalesce(cd_cid_principal,0))),1,100) 
	into STRICT	ds_indicacao_clinica_w 
	from 	w_interf_conta_cab 
	where	nr_interno_conta = nr_interno_conta_w 
	and 	nr_seq_protocolo = nr_seq_protocolo_p;
 
	if (coalesce(ds_indicacao_clinica_w::text, '') = '') then 
 		ds_erro_w:= WHEB_MENSAGEM_PCK.get_texto(280126) || nr_interno_conta_w || ')';
	end if;
 
	/* Pega 20 itens da conta */
 
	OPEN C02;
	LOOP 
	FETCH C02 into 
		cd_item_w, 
		ds_item_w, 
		vl_item_w;	
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin		 
		contador_w:= contador_w + 1;	
		if (contador_w = 1) then 
			ds_item_w:= substr(ds_item_w,1,20);	
			ds_item_w:= rpad(ds_item_w, 20);
		else 
			ds_item_w:= rpad(ds_item_w, 40);
		end if;
		vl_item_w:= obter_Valor_sem_virgula((vl_item_w)::numeric );
		vl_item_w:= lpad(vl_item_w, 6, 0);
		ds_lista_item_w:= ds_lista_item_w || ds_item_w || ';' || vl_item_w || ';';
 
		end;
	END LOOP;
	CLOSE C02;
	/* Conta com menos de 20 Items */
 
	while(contador_w < 20) loop 
		begin 
		contador_w:= contador_w + 1;		
		ds_item_w:= rpad(' ', 40);
		vl_item_w:= lpad(0, 6, 0);
		ds_lista_item_w:= ds_lista_item_w || ds_item_w || ';' || vl_item_w || ';';
 
		end;
	end loop;
 
	/* Retira o ultimo ';' do ds_lista_w */
 
	ie_troca_w:= 'N';
	for i IN REVERSE length(ds_lista_item_w)..1 loop 
		begin 
    	if (Substr(ds_lista_item_w, i, 1) = ';') and (ie_troca_w = 'N') then 
			ds_lista_item_w:= Substr(ds_lista_item_w, 1, i - 1);
			ie_troca_w:= 'S';
		end if;
		end;
	END loop;
 
	cd_guia_w:= lpad(cd_guia_w, 10, 0);
	ds_indicacao_clinica_w:= rpad(ds_indicacao_clinica_w, 100);
	cd_processo_autoriz_w:= lpad(cd_processo_autoriz_p, 10, 0);
 
	insert into w_conta_assim(nr_seq_protocolo, 
			nr_interno_conta, 
			cd_processo_autoriz, 
			cd_guia_autorizador, 
			ds_indicacao_clinica, 
			ds_lista_item) 
		values (nr_seq_protocolo_p, 
			nr_interno_conta_w, 
			cd_processo_autoriz_w, 
			(cd_guia_w)::numeric , 
			ds_indicacao_clinica_w, 
			ds_lista_item_w);
	end;
END LOOP;
CLOSE C01;
 
ds_erro_p:= ds_erro_w;
 
commit;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_interface_assim ( cd_processo_autoriz_p text, nr_seq_protocolo_p bigint, ds_erro_p INOUT text) FROM PUBLIC;

