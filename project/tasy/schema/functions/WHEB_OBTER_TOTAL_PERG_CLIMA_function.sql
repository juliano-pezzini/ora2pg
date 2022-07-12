-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION wheb_obter_total_perg_clima (nr_seq_sequencia_p bigint, nr_seq_superior_p bigint, cd_setor_p bigint) RETURNS bigint AS $body$
DECLARE


qt_total_w	bigint;


BEGIN

if (nr_seq_superior_p = 11515) then
	select	count(*) qt_registro
	into STRICT	qt_total_w
	from (
		SELECT	CASE WHEN b.qt_resultado=1 THEN 'Ótimo' WHEN b.qt_resultado=2 THEN 'Bom' WHEN b.qt_resultado=3 THEN 'Regular' WHEN b.qt_resultado=4 THEN 'Ruim' WHEN b.qt_resultado=5 THEN 'Péssimo' END  ds_resposta,
		b.qt_resultado
		from	med_tipo_avaliacao	d,
			med_item_avaliar_v	c,
			sac_pesquisa_result	b,
			sac_pesquisa 		a
		where	a.nr_sequencia		= b.nr_seq_pesquisa
		and	b.nr_seq_item		= c.nr_sequencia
		and	c.nr_seq_tipo		= d.nr_sequencia
		and	a.nr_seq_tipo_avaliacao	= 491
		and	c.nr_sequencia		= nr_seq_sequencia_p
		and	c.nr_seq_superior		= 11515
		and     exists (SELECT 1
		        from    sac_pesquisa_result x
		        where   x.nr_seq_item   = 11514
		        and     x.qt_resultado  = cd_setor_p
	    		and     x.nr_seq_pesquisa = b.nr_seq_pesquisa)
		) a;
elsif (nr_seq_superior_p = 11522) then
	select	count(*) qt_registro
	into STRICT	qt_total_w
	from (
	SELECT	c.ds_item ds_resposta,
		c.nr_seq_apresent
	from	med_item_avaliar_v	c,
		sac_pesquisa_result	b,
		sac_pesquisa 		a
	where	a.nr_sequencia		= b.nr_seq_pesquisa
	and	b.nr_seq_item		= c.nr_sequencia
	and	a.nr_seq_tipo_avaliacao	= 491
	and	c.nr_seq_superior		= nr_seq_sequencia_p
	and     exists (SELECT 1
	        from    sac_pesquisa_result x
	        where   x.nr_seq_item   = 11514
	        and     x.qt_resultado  = cd_setor_p
	        and     x.nr_seq_pesquisa = b.nr_seq_pesquisa)
	and	c.nr_seq_superior in (11523,11530,11538,11545,11554,11561,11569,11576)) a;

elsif (nr_seq_superior_p = 11583) then
	select	sum(qt_registro)
	into STRICT	qt_total_w
	from (
	SELECT	b.qt_resultado,
		CASE WHEN b.qt_resultado=1 THEN 'Ótimo' WHEN b.qt_resultado=2 THEN 'Bom' WHEN b.qt_resultado=3 THEN 'Regular' WHEN b.qt_resultado=4 THEN 'Ruim' WHEN b.qt_resultado=5 THEN 'Péssimo' END  ds_resposta,
		count(*) qt_registro
	from	med_tipo_avaliacao	d,
		med_item_avaliar_v	c,
		sac_pesquisa_result	b,
		sac_pesquisa 		a
	where	a.nr_sequencia		= b.nr_seq_pesquisa
	and	b.nr_seq_item		= c.nr_sequencia
	and	c.nr_seq_tipo		= d.nr_sequencia
	and	a.nr_seq_tipo_avaliacao	= 491
	and	c.nr_seq_apresent		= 180
	and     exists (SELECT 1
	        from    sac_pesquisa_result x
	        where   x.nr_seq_item   = 11514
	        and     x.qt_resultado  = cd_setor_p
	        and     x.nr_seq_pesquisa = b.nr_seq_pesquisa)
	and	c.nr_sequencia		= nr_seq_sequencia_p
	and	c.nr_seq_superior		= 11583
	group by b.qt_resultado
	
union

	select	b.qt_resultado,
		CASE WHEN b.qt_resultado=1 THEN 'Concordo totalmente' WHEN b.qt_resultado=2 THEN 'Concordo em parte' WHEN b.qt_resultado=3 THEN 'Não concordo, nem discordo' WHEN b.qt_resultado=4 THEN 'Discordo totalmente' WHEN b.qt_resultado=5 THEN 'Discordo em parte' WHEN b.qt_resultado=6 THEN 'NR' END  ds_resposta,
		count(*) qt_registro
	from	med_tipo_avaliacao	d,
		med_item_avaliar_v	c,
		sac_pesquisa_result	b,
		sac_pesquisa 		a
	where	a.nr_sequencia		= b.nr_seq_pesquisa
	and	b.nr_seq_item		= c.nr_sequencia
	and	c.nr_seq_tipo		= d.nr_sequencia
	and	a.nr_seq_tipo_avaliacao	= 491
	and	c.nr_seq_apresent in (171,190,200,210)
	and	c.nr_sequencia		= nr_seq_sequencia_p
	and	c.nr_seq_superior		= 11583
	and     exists (select 1
	        from    sac_pesquisa_result x
	        where   x.nr_seq_item   = 11514
	        and     x.qt_resultado  = cd_setor_p
	        and     x.nr_seq_pesquisa = b.nr_seq_pesquisa)
	group by	b.qt_resultado) a;
elsif (nr_seq_superior_p = 11589) then
	select	sum(qt_registro)
	into STRICT	qt_total_w
	from (
	SELECT	b.qt_resultado,
		CASE WHEN b.qt_resultado=1 THEN 'Sempre' WHEN b.qt_resultado=2 THEN 'Às vezes' WHEN b.qt_resultado=3 THEN 'Raramente' WHEN b.qt_resultado=4 THEN 'Nunca' WHEN b.qt_resultado=5 THEN 'NR' END  ds_resposta,
		count(*) qt_registro
	from	med_tipo_avaliacao	d,
		med_item_avaliar_v	c,
		sac_pesquisa_result	b,
		sac_pesquisa 		a
	where	a.nr_sequencia		= b.nr_seq_pesquisa
	and	b.nr_seq_item		= c.nr_sequencia
	and	c.nr_seq_tipo		= d.nr_sequencia
	and	a.nr_seq_tipo_avaliacao	= 491
	and	c.nr_seq_apresent in (230,240,250)
	and	c.nr_sequencia		= nr_seq_sequencia_p
	and	c.nr_seq_superior		= 11589
	and     exists (SELECT 1
	        from    sac_pesquisa_result x
	        where   x.nr_seq_item   = 11514
	        and     x.qt_resultado  = cd_setor_p
	        and     x.nr_seq_pesquisa = b.nr_seq_pesquisa)
	group by b.qt_resultado
	
union

	select	b.qt_resultado,
		CASE WHEN b.qt_resultado=1 THEN 'Ótimo' WHEN b.qt_resultado=2 THEN 'Bom' WHEN b.qt_resultado=3 THEN 'Regular' WHEN b.qt_resultado=4 THEN 'Ruim' WHEN b.qt_resultado=5 THEN 'Péssimo' END  ds_resposta,
		count(*) qt_registro
	from	med_tipo_avaliacao	d,
		med_item_avaliar_v	c,
		sac_pesquisa_result	b,
		sac_pesquisa 		a
	where	a.nr_sequencia		= b.nr_seq_pesquisa
	and	b.nr_seq_item		= c.nr_sequencia
	and	c.nr_seq_tipo		= d.nr_sequencia
	and	a.nr_seq_tipo_avaliacao	= 491
	and	c.nr_seq_apresent		= 280
	and	c.nr_sequencia		= nr_seq_sequencia_p
	and	c.nr_seq_superior		= 11589
	and     exists (select 1
	        from    sac_pesquisa_result x
	        where   x.nr_seq_item   = 11514
	        and     x.qt_resultado  = cd_setor_p
	        and     x.nr_seq_pesquisa = b.nr_seq_pesquisa)
	group by b.qt_resultado
	
union

	select	b.qt_resultado,
		CASE WHEN b.qt_resultado=1 THEN 'Concordo totalmente' WHEN b.qt_resultado=2 THEN 'Concordo em parte' WHEN b.qt_resultado=3 THEN 'Não concordo, nem discordo' WHEN b.qt_resultado=4 THEN 'Discordo totalmente' WHEN b.qt_resultado=5 THEN 'Discordo em parte' WHEN b.qt_resultado=6 THEN 'NR' END  ds_resposta,
		count(*) qt_registro
	from	med_tipo_avaliacao	d,
		med_item_avaliar_v	c,
		sac_pesquisa_result	b,
		sac_pesquisa 		a
	where	a.nr_sequencia		= b.nr_seq_pesquisa
	and	b.nr_seq_item		= c.nr_sequencia
	and	c.nr_seq_tipo		= d.nr_sequencia
	and	a.nr_seq_tipo_avaliacao	= 491
	and	c.nr_seq_apresent in (260,270)
	and	c.nr_sequencia		= nr_seq_sequencia_p
	and	c.nr_seq_superior		= 11589
	and     exists (select 1
	        from    sac_pesquisa_result x
	        where   x.nr_seq_item   = 11514
	        and     x.qt_resultado  = cd_setor_p
	        and     x.nr_seq_pesquisa = b.nr_seq_pesquisa)
	group by	b.qt_resultado) a;
elsif (nr_seq_superior_p = 11597) then
	select	count(*) qt_registro
	into STRICT	qt_total_w
	from (
	SELECT	c.ds_item ds_resposta,
		c.nr_seq_apresent
	from	med_item_avaliar_v	c,
		sac_pesquisa_result	b,
		sac_pesquisa 		a
	where	a.nr_sequencia		= b.nr_seq_pesquisa
	and	b.nr_seq_item		= c.nr_sequencia
	and	a.nr_seq_tipo_avaliacao	= 491
	and	c.nr_seq_superior		= nr_seq_sequencia_p
	and     exists (SELECT 1
	        from    sac_pesquisa_result x
	        where   x.nr_seq_item   = 11514
	        and     x.qt_resultado  = cd_setor_p
	        and     x.nr_seq_pesquisa = b.nr_seq_pesquisa)
	and	c.nr_seq_superior in (11599,11605,11611,11618)) a;
elsif (nr_seq_superior_p = 11625) then
	select	sum(qt_registro)
	into STRICT	qt_total_w
	from (
	SELECT	b.qt_resultado,
		CASE WHEN b.qt_resultado=1 THEN 'Gerente de Desenvolvimento' WHEN b.qt_resultado=2 THEN 'Gerente de Suporte' WHEN b.qt_resultado=3 THEN 'Gerente de Tecnologia' WHEN b.qt_resultado=4 THEN 'Gerente de Projetos' WHEN b.qt_resultado=5 THEN 'Gerente de Vendas' WHEN b.qt_resultado=6 THEN 'Gerente de Marketing' WHEN b.qt_resultado=7 THEN 'Diretor Administrativo/Financeiros' WHEN b.qt_resultado=8 THEN 'Diretora Comercial' WHEN b.qt_resultado=9 THEN 'Diretor Operacional' END  ds_resposta,
		count(*) qt_registro
	from	med_tipo_avaliacao	d,
		med_item_avaliar_v	c,
		sac_pesquisa_result	b,
		sac_pesquisa 		a
	where	a.nr_sequencia		= b.nr_seq_pesquisa
	and	b.nr_seq_item		= c.nr_sequencia
	and	c.nr_seq_tipo		= d.nr_sequencia
	and	a.nr_seq_tipo_avaliacao	= 491
	and	c.nr_seq_apresent 		= 352
	and	c.nr_sequencia		= nr_seq_sequencia_p
	and	c.nr_seq_superior		= 11625
	and     exists (SELECT 1
	        from    sac_pesquisa_result x
	        where   x.nr_seq_item   = 11514
	        and     x.qt_resultado  = cd_setor_p
	        and     x.nr_seq_pesquisa = b.nr_seq_pesquisa)
	group by b.qt_resultado
	
union

	select	b.qt_resultado,
		CASE WHEN b.qt_resultado=1 THEN 'Sempre' WHEN b.qt_resultado=2 THEN 'Às vezes' WHEN b.qt_resultado=3 THEN 'Raramente' WHEN b.qt_resultado=4 THEN 'Nunca' WHEN b.qt_resultado=5 THEN 'NR' END  ds_resposta,
		count(*) qt_registro
	from	med_tipo_avaliacao	d,
		med_item_avaliar_v	c,
		sac_pesquisa_result	b,
		sac_pesquisa 		a
	where	a.nr_sequencia		= b.nr_seq_pesquisa
	and	b.nr_seq_item		= c.nr_sequencia
	and	c.nr_seq_tipo		= d.nr_sequencia
	and	a.nr_seq_tipo_avaliacao	= 491
	and	c.nr_seq_apresent in (360,370,390)
	and	c.nr_sequencia		= nr_seq_sequencia_p
	and	c.nr_seq_superior		= 11625
	and     exists (select 1
	        from    sac_pesquisa_result x
	        where   x.nr_seq_item   = 11514
	        and     x.qt_resultado  = cd_setor_p
	        and     x.nr_seq_pesquisa = b.nr_seq_pesquisa)
	group by b.qt_resultado
	
union

	select	b.qt_resultado,
		CASE WHEN b.qt_resultado=1 THEN 'Ótimo' WHEN b.qt_resultado=2 THEN 'Bom' WHEN b.qt_resultado=3 THEN 'Regular' WHEN b.qt_resultado=4 THEN 'Ruim' WHEN b.qt_resultado=5 THEN 'Péssimo' END  ds_resposta,
		count(*) qt_registro
	from	med_tipo_avaliacao	d,
		med_item_avaliar_v	c,
		sac_pesquisa_result	b,
		sac_pesquisa 		a
	where	a.nr_sequencia		= b.nr_seq_pesquisa
	and	b.nr_seq_item		= c.nr_sequencia
	and	c.nr_seq_tipo		= d.nr_sequencia
	and	a.nr_seq_tipo_avaliacao	= 491
	and	c.nr_seq_apresent		= 410
	and	c.nr_sequencia		= nr_seq_sequencia_p
	and	c.nr_seq_superior		= 11625
	and     exists (select 1
	        from    sac_pesquisa_result x
	        where   x.nr_seq_item   = 11514
	        and     x.qt_resultado  = cd_setor_p
	        and     x.nr_seq_pesquisa = b.nr_seq_pesquisa)
	group by b.qt_resultado
	
union

	select	b.qt_resultado,
		CASE WHEN b.qt_resultado=1 THEN 'Concordo totalmente' WHEN b.qt_resultado=2 THEN 'Concordo em parte' WHEN b.qt_resultado=3 THEN 'Não concordo, nem discordo' WHEN b.qt_resultado=4 THEN 'Discordo totalmente' WHEN b.qt_resultado=5 THEN 'Discordo em parte' WHEN b.qt_resultado=6 THEN 'NR' END  ds_resposta,
		count(*) qt_registro
	from	med_tipo_avaliacao	d,
		med_item_avaliar_v	c,
		sac_pesquisa_result	b,
		sac_pesquisa 		a
	where	a.nr_sequencia		= b.nr_seq_pesquisa
	and	b.nr_seq_item		= c.nr_sequencia
	and	c.nr_seq_tipo		= d.nr_sequencia
	and	a.nr_seq_tipo_avaliacao	= 491
	and	c.nr_seq_apresent in (380,400,420)
	and	c.nr_sequencia		= nr_seq_sequencia_p
	and	c.nr_seq_superior		= 11625
	and     exists (select 1
	        from    sac_pesquisa_result x
	        where   x.nr_seq_item   = 11514
	        and     x.qt_resultado  = cd_setor_p
	        and     x.nr_seq_pesquisa = b.nr_seq_pesquisa)
	group by	b.qt_resultado) a;
elsif (nr_seq_sequencia_p in (11645, 11659)) then
	select	count(*) qt_registro
	into STRICT	qt_total_w
	from (
	SELECT	c.ds_item ds_resposta,
		c.nr_seq_apresent
	from	med_item_avaliar_v	c,
		sac_pesquisa_result	b,
		sac_pesquisa 		a
	where	a.nr_sequencia		= b.nr_seq_pesquisa
	and	b.nr_seq_item		= c.nr_sequencia
	and	a.nr_seq_tipo_avaliacao	= 491
	and	c.nr_seq_superior		= nr_seq_sequencia_p
	and     exists (SELECT 1
	        from    sac_pesquisa_result x
	        where   x.nr_seq_item   = 11514
	        and     x.qt_resultado  = cd_setor_p
	        and     x.nr_seq_pesquisa = b.nr_seq_pesquisa)
	and	c.nr_seq_superior in (11645,11659)) a;
elsif (nr_seq_superior_p = 11635) then
	select	sum(qt_registro)
	into STRICT	qt_total_w
	from (
	SELECT	b.qt_resultado,
		CASE WHEN b.qt_resultado=1 THEN 'Concordo totalmente' WHEN b.qt_resultado=2 THEN 'Concordo em parte' WHEN b.qt_resultado=3 THEN 'Não concordo, nem discordo' WHEN b.qt_resultado=4 THEN 'Discordo totalmente' WHEN b.qt_resultado=5 THEN 'Discordo em parte' WHEN b.qt_resultado=6 THEN 'NR' END  ds_resposta,
		count(*) qt_registro
	from	med_tipo_avaliacao	d,
		med_item_avaliar_v	c,
		sac_pesquisa_result	b,
		sac_pesquisa 		a
	where	a.nr_sequencia		= b.nr_seq_pesquisa
	and	b.nr_seq_item		= c.nr_sequencia
	and	c.nr_seq_tipo		= d.nr_sequencia
	and	a.nr_seq_tipo_avaliacao	= 491
	and	c.nr_seq_apresent in (460, 470)
	and	c.nr_sequencia		= nr_seq_sequencia_p
	and	c.nr_seq_superior		= 11635
	and     exists (SELECT 1
	        from    sac_pesquisa_result x
	        where   x.nr_seq_item   = 11514
	        and     x.qt_resultado  = cd_setor_p
	        and     x.nr_seq_pesquisa = b.nr_seq_pesquisa)
	group by b.qt_resultado
	
union

	select	b.qt_resultado,
		CASE WHEN b.qt_resultado=1 THEN 'Trabalhar na Wheb na mesma função atual' WHEN b.qt_resultado=2 THEN 'Trabalhar na Wheb em outra função' WHEN b.qt_resultado=3 THEN 'Trabalhar em outra empresa com a mesma função atual' WHEN b.qt_resultado=4 THEN 'Trabalhar em outra empresa em outra função' WHEN b.qt_resultado=5 THEN 'NR' END  ds_resposta,
		count(*) qt_registro
	from	med_tipo_avaliacao	d,
		med_item_avaliar_v	c,
		sac_pesquisa_result	b,
		sac_pesquisa 		a
	where	a.nr_sequencia		= b.nr_seq_pesquisa
	and	b.nr_seq_item		= c.nr_sequencia
	and	c.nr_seq_tipo		= d.nr_sequencia
	and	a.nr_seq_tipo_avaliacao	= 491
	and	c.nr_seq_apresent		= 480
	and	c.nr_sequencia		= nr_seq_sequencia_p
	and	c.nr_seq_superior		= 11635
	and     exists (select 1
	        from    sac_pesquisa_result x
	        where   x.nr_seq_item   = 11514
	        and     x.qt_resultado  = cd_setor_p
	        and     x.nr_seq_pesquisa = b.nr_seq_pesquisa)
	group by b.qt_resultado
	
union

	select	b.qt_resultado,
		CASE WHEN b.qt_resultado=1 THEN 'Melhores do que hoje' WHEN b.qt_resultado=2 THEN 'Igual ao que é hoje' WHEN b.qt_resultado=3 THEN 'Pior do que é hoje' WHEN b.qt_resultado=4 THEN 'NR' END  ds_resposta,
		count(*) qt_registro
	from	med_tipo_avaliacao	d,
		med_item_avaliar_v	c,
		sac_pesquisa_result	b,
		sac_pesquisa 		a
	where	a.nr_sequencia		= b.nr_seq_pesquisa
	and	b.nr_seq_item		= c.nr_sequencia
	and	c.nr_seq_tipo		= d.nr_sequencia
	and	a.nr_seq_tipo_avaliacao	= 491
	and	c.nr_seq_apresent		= 490
	and	c.nr_sequencia		= nr_seq_sequencia_p
	and	c.nr_seq_superior		= 11635
	and     exists (select 1
	        from    sac_pesquisa_result x
	        where   x.nr_seq_item   = 11514
	        and     x.qt_resultado  = cd_setor_p
	        and     x.nr_seq_pesquisa = b.nr_seq_pesquisa)
	group by b.qt_resultado) a;
elsif (nr_seq_superior_p = 11671) then
	select	sum(qt_registro)
	into STRICT	qt_total_w
	from (
	SELECT	b.qt_resultado,
		CASE WHEN b.qt_resultado=1 THEN 'Sempre' WHEN b.qt_resultado=2 THEN 'Às vezes' WHEN b.qt_resultado=3 THEN 'Raramente' WHEN b.qt_resultado=4 THEN 'Nunca' WHEN b.qt_resultado=5 THEN 'NR' END  ds_resposta,
		count(*) qt_registro
	from	med_tipo_avaliacao	d,
		med_item_avaliar_v	c,
		sac_pesquisa_result	b,
		sac_pesquisa 		a
	where	a.nr_sequencia		= b.nr_seq_pesquisa
	and	b.nr_seq_item		= c.nr_sequencia
	and	c.nr_seq_tipo		= d.nr_sequencia
	and	a.nr_seq_tipo_avaliacao	= 491
	and	c.nr_seq_apresent in (820,830)
	and	c.nr_sequencia		= nr_seq_sequencia_p
	and	c.nr_seq_superior		= 11671
	and     exists (SELECT 1
	        from    sac_pesquisa_result x
	        where   x.nr_seq_item   = 11514
	        and     x.qt_resultado  = cd_setor_p
	        and     x.nr_seq_pesquisa = b.nr_seq_pesquisa)
	group by b.qt_resultado
	
union

	select	b.qt_resultado,
		CASE WHEN b.qt_resultado=1 THEN 'Concordo totalmente' WHEN b.qt_resultado=2 THEN 'Concordo em parte' WHEN b.qt_resultado=3 THEN 'Não concordo, nem discordo' WHEN b.qt_resultado=4 THEN 'Discordo totalmente' WHEN b.qt_resultado=5 THEN 'Discordo em parte' WHEN b.qt_resultado=6 THEN 'NR' END  ds_resposta,
		count(*) qt_registro
	from	med_tipo_avaliacao	d,
		med_item_avaliar_v	c,
		sac_pesquisa_result	b,
		sac_pesquisa 		a
	where	a.nr_sequencia		= b.nr_seq_pesquisa
	and	b.nr_seq_item		= c.nr_sequencia
	and	c.nr_seq_tipo		= d.nr_sequencia
	and	a.nr_seq_tipo_avaliacao	= 491
	and	c.nr_seq_apresent		= 810
	and	c.nr_sequencia		= nr_seq_sequencia_p
	and	c.nr_seq_superior		= 11671
	and     exists (select 1
	        from    sac_pesquisa_result x
	        where   x.nr_seq_item   = 11514
	        and     x.qt_resultado  = cd_setor_p
	        and     x.nr_seq_pesquisa = b.nr_seq_pesquisa)
	group by	b.qt_resultado) a;
elsif (nr_seq_superior_p = 11676) then
	select	sum(qt_registro)
	into STRICT	qt_total_w
	from (
	SELECT	b.qt_resultado,
		CASE WHEN b.qt_resultado=1 THEN 'Muito satisfeito' WHEN b.qt_resultado=2 THEN 'Satisfeito' WHEN b.qt_resultado=3 THEN 'Mais ou menos satisfeito' WHEN b.qt_resultado=4 THEN 'Pouco satisfeito' WHEN b.qt_resultado=5 THEN 'Nada satisfeito' WHEN b.qt_resultado=6 THEN 'NR' END  ds_resposta,
		count(*) qt_registro
	from	med_tipo_avaliacao	d,
		med_item_avaliar_v	c,
		sac_pesquisa_result	b,
		sac_pesquisa 		a
	where	a.nr_sequencia		= b.nr_seq_pesquisa
	and	b.nr_seq_item		= c.nr_sequencia
	and	c.nr_seq_tipo		= d.nr_sequencia
	and	a.nr_seq_tipo_avaliacao	= 491
	and	c.nr_sequencia		= nr_seq_sequencia_p
	and	c.nr_seq_superior	= 11676
	and     exists (SELECT 1
	        from    sac_pesquisa_result x
	        where   x.nr_seq_item   = 11514
	        and     x.qt_resultado  = cd_setor_p
	        and     x.nr_seq_pesquisa = b.nr_seq_pesquisa)
	group by b.qt_resultado) a;
elsif (nr_seq_superior_p = 11679) then
	select	sum(qt_registro)
	into STRICT	qt_total_w
	from (
	SELECT	b.qt_resultado,
		CASE WHEN b.qt_resultado=1 THEN 'Ótimo' WHEN b.qt_resultado=2 THEN 'Bom' WHEN b.qt_resultado=3 THEN 'Regular' WHEN b.qt_resultado=4 THEN 'Ruim' WHEN b.qt_resultado=5 THEN 'Péssimo' WHEN b.qt_resultado=6 THEN 'NR' END  ds_resposta,
		count(*) qt_registro
	from	med_tipo_avaliacao		d,
		med_item_avaliar_v		c,
		sac_pesquisa_result	b,
		sac_pesquisa 		a
	where	a.nr_sequencia		= b.nr_seq_pesquisa
	and	b.nr_seq_item		= c.nr_sequencia
	and	c.nr_seq_tipo		= d.nr_sequencia
	and	a.nr_seq_tipo_avaliacao	= 491
	and	c.nr_sequencia		= nr_seq_sequencia_p
	and	c.nr_seq_superior		= 11680
	and     exists (SELECT 1
	        from    sac_pesquisa_result x
	        where   x.nr_seq_item   = 11514
	        and     x.qt_resultado  = cd_setor_p
	        and     x.nr_seq_pesquisa = b.nr_seq_pesquisa)
	group by b.qt_resultado) a;



end if;

return	qt_total_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION wheb_obter_total_perg_clima (nr_seq_sequencia_p bigint, nr_seq_superior_p bigint, cd_setor_p bigint) FROM PUBLIC;
